#!/usr/bin/env python3

import os
import subprocess
import argparse
import sys
import termios
import tty

CUR_DIR = os.path.dirname(os.path.realpath(__file__))


def select_options(options, desc="Select options"):
    selected = [True] * len(options)
    for i, option in enumerate(options):
        if isinstance(option, tuple):
            options[i] = option[0]
            selected[i] = option[1]

    index = 0

    num_printed_lines = 0

    def _print(*args, **kwargs):
        nonlocal num_printed_lines
        num_printed_lines += 1
        print(*args, **kwargs)

    while True:
        # Clear the screen
        print(f"\033[F" * num_printed_lines, end="")
        num_printed_lines = 0
        _print(desc)
        _print("Select options (use arrow keys to navigate, space/enter to select, 'q' to finish, 'a' to add new custom option, Ctrl+C to exit):")
        for idx, option in enumerate(options):
            prefix = "[x]" if selected[idx] else "[ ]"
            if idx == index:
                _print(f"> {prefix} {option}")
            else:
                _print(f"  {prefix} {option}")
        _print()

        fd = sys.stdin.fileno()
        old_settings = termios.tcgetattr(fd)
        try:
            tty.setraw(sys.stdin.fileno())
            key = sys.stdin.read(1)
        finally:
            termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)

        if key == "q":
            break
        elif key == "\x1b":  # Arrow keys
            key += sys.stdin.read(2)
            if key == "\x1b[A":  # Up arrow
                index = (index - 1) % len(options)
            elif key == "\x1b[B":  # Down arrow
                index = (index + 1) % len(options)
        elif key == " " or key == "\n" or key == "\r":
            selected[index] = not selected[index]
        elif key == "a":
            guide = "Enter new option: "
            new_option = input(guide)
            print("\033[F" + "\b" * (len(guide) + len(new_option) + 1) + " " * (len(guide) + len(new_option) + 1), end="")
            options.append(new_option)
            selected.append(True)
        # Ctrl+C to break out of the loop
        elif key == "\x03":
            exit(1)

    selected_options = [option for i, option in enumerate(options) if selected[i]]
    return selected_options

def dn(container_name=None, image_name=None):
    if not container_name:
        print("Usage: dn <container_name> <image_name>")
        return

    # Check if sudo is required to run docker commands
    sudo = "" if "docker" in subprocess.getoutput("groups") else "sudo"

    user_id = subprocess.getoutput("id -u")
    group_id = subprocess.getoutput("id -g")
    user_name = subprocess.getoutput("whoami")

    is_home = os.path.expanduser('~') == f"/home/{user_name}"

    default_opts = [
        (f"-v {os.path.expanduser('~')}/conda:/home/{user_name}/conda", False),
        "-v /:/host",
        "--gpus all",
        f"-v {os.path.expanduser('~')}/.cache:/home/{user_name}/.cache",
        (f"-v {os.path.expanduser('~')}/.local:/home/{user_name}/.local", False),
        f"-v {os.path.expanduser('~')}/.ssh:/home/{user_name}/.ssh",
        "--ipc=host",
        "--shm-size=8g",
    ]

    selected_opts = select_options(default_opts, desc=f"Select options for container {container_name} (image: {image_name})")
    print("Selected options:", " ".join(selected_opts))

    if not image_name:
        image_name = f"{os.getlogin()}-default"
        # Check if image exists. If not, build it from ${CUR_DIR}/Dockerfile
        if not subprocess.getoutput(f"{sudo} docker images -q {image_name}"):
            print(f"Image {image_name} does not exist")
            print(f"Building image {image_name} from {CUR_DIR}/Dockerfile")
            cmd = f"{sudo} docker build -t {image_name} --build-arg USER_ID={user_id} --build-arg GROUP_ID={group_id} --build-arg USER_NAME={user_name} {CUR_DIR} -f {CUR_DIR}/Dockerfile"
            subprocess.run(cmd, shell=True)

    # Check if container is running
    if subprocess.call(f"{sudo} docker container inspect {container_name} > /dev/null 2>&1", shell=True) == 0:
        yn = input(f"Container {container_name} is already running. Do you want to stop and recreate the container? [y/n] ")
        if yn.lower() == 'y':
            subprocess.run(f"{sudo} docker stop {container_name} && {sudo} docker rm {container_name}", shell=True)
            print(f"Creating and starting container {container_name}")
            subprocess.run(f"{sudo} docker run -d -it -u {user_id}:{group_id} {' '.join(selected_opts)} --name {container_name} {image_name} /bin/zsh", shell=True)
        else:
            print("Exiting...")
    else:
        print(f"Creating and starting container {container_name}")
        subprocess.run(f"{sudo} docker run -d -it -u {user_id}:{group_id} {' '.join(selected_opts)} --name {container_name} {image_name} /bin/zsh", shell=True)

def da(container_name):
    if not container_name:
        print("Usage: da <container_name>")
        return

    # Check if sudo is required to run docker commands
    sudo = "" if "docker" in subprocess.getoutput("groups") else "sudo"

    # Check if container exists
    if subprocess.call(f"{sudo} docker container inspect {container_name} > /dev/null 2>&1", shell=True) == 0:
        # Check if container is running
        is_running = subprocess.getoutput(f"{sudo} docker container inspect --format='{{{{.State.Running}}}}' {container_name}") == "true"
        if is_running:
            print(f"Attaching to running container: {container_name}")
            subprocess.run(f"{sudo} docker exec -it {container_name} /bin/zsh", shell=True)
        else:
            print(f"Starting container: {container_name}")
            subprocess.run(f"{sudo} docker start {container_name}", shell=True)
            print(f"Attaching to container: {container_name}")
            subprocess.run(f"{sudo} docker exec -it {container_name} /bin/zsh", shell=True)
    else:
        print(f"Container {container_name} does not exist")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="A script with multiple commands.")
    subparsers = parser.add_subparsers(dest="command", help="Subcommands")

    # 'dn' command
    parser_dn = subparsers.add_parser('dn', help="Run 'dn (= docker create)' command")
    parser_dn.add_argument('container_name', nargs='?', help="Container name")
    parser_dn.add_argument('image_name', nargs='?', help="Image name")

    # 'da' command
    parser_da = subparsers.add_parser('da', help="Run 'da (= docker activate)' command")
    parser_da.add_argument('container_name', nargs='?', help="Container name")

    args = parser.parse_args()

    if args.command == "dn":
        dn(args.container_name, args.image_name)
    elif args.command == "da":
        da(args.container_name)
    else:
        parser.print_help()
        sys.exit(1)
