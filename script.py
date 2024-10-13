#!/usr/bin/env python3

import os
import subprocess
import sys
import termios
import tty

def select_options(options):
    selected = [True] * len(options)
    index = 0

    while True:
        os.system('clear')
        print("\nSelect options (use arrow keys to navigate, space/enter to select, 'q' to finish, 'a' to add new custom option, Ctrl+C to exit)")
        for idx, option in enumerate(options):
            prefix = "[x]" if selected[idx] else "[ ]"
            if idx == index:
                print(f"> {prefix} {option}")
            else:
                print(f"  {prefix} {option}")

        fd = sys.stdin.fileno()
        old_settings = termios.tcgetattr(fd)
        try:
            tty.setraw(sys.stdin.fileno())
            key = sys.stdin.read(1)

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
                new_option = input("Enter new option: ")
                options.append(new_option)
                selected.append(True)
            # Ctrl+C to break out of the loop
            elif key == "\x03":
                exit(1)
        finally:
            termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)

    selected_options = [option for i, option in enumerate(options) if selected[i]]
    return selected_options

def dn(container_name=None, image_name=None):
    default_opts = [
        f"-v {os.path.expanduser('~')}/conda:{os.path.expanduser('~')}/conda",
        "-v /:/host",
        "--gpus all",
        f"-v {os.path.expanduser('~')}/.cache:{os.path.expanduser('~')}/.cache"
    ]

    selected_opts = select_options(default_opts)
    print("Selected options:", " ".join(selected_opts))

    if not container_name:
        print("Usage: dn <container_name> <image_name>")
        return

    # Check if sudo is required to run docker commands
    sudo = "" if "docker" in subprocess.getoutput("groups") else "sudo"

    user_id = subprocess.getoutput("id -u")
    group_id = subprocess.getoutput("id -g")
    user_name = subprocess.getoutput("whoami")

    if not image_name:
        image_name = f"{os.getlogin()}-default"
        # Check if image exists. If not, build it from $HOME/.dotfiles/Dockerfile
        if not subprocess.getoutput(f"{sudo} docker images -q {image_name}"):
            print(f"Image {image_name} does not exist")
            print(f"Building image {image_name} from $HOME/.dotfiles/Dockerfile")
            cmd = f"{sudo} docker build -t {image_name} --build-arg USER_ID={user_id} --build-arg GROUP_ID={group_id} --build-arg USER_NAME={user_name} -f $HOME/.dotfiles/Dockerfile"
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
    if len(sys.argv) < 2:
        print("Usage: python script.py <command> [<args>...]")
        sys.exit(1)

    command = sys.argv[1]

    if command == "dn":
        container_name = sys.argv[2] if len(sys.argv) > 2 else None
        image_name = sys.argv[3] if len(sys.argv) > 3 else None
        dn(container_name, image_name)
    elif command == "da":
        container_name = sys.argv[2] if len(sys.argv) > 2 else None
        da(container_name)
    else:
        print(f"Unknown command: {command}")
        sys.exit(1)
