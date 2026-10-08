import os

subnet = "192.168.1.0"
submask = "24"

log_dir = "$env:USERPROFILE\Documents\TargetLogs"
timestamp = datetime.now().strftime("%Y-%m-%d")


def check_root():
        
    if os.getuid() != 0:
        print("This sript must be run as root", file=sys.stderr)
        sys.exit(1)


def validate_path(path):
        
    if not os.path.exists(path):
        print("Path does not exist..")
        print("Creating path..")
        try:
            os.makedir(path)
            print("Path has been created")
            print(path)
        except Exception as e:
            print(f"An error has occured: {e}")


def validate file(file):
        
    if not os.path.isfile(file):
        print("Log file does not exist..")
        print("Creating file..")
        try:
            with open("scan.xml", "x") as f:
                f.write('<?xml version="1.0" encoding="UTF-8"?>\n')
                f.write("<root></root>\n")


def validate_winget():
        
    if not shutil.which("winget.exe"):
        print("Winget cannot be found..")


def validate_nmap():
        
    if not shutil.which("nmap.exe"):
        print("Nmap cannot be found..")
        print("Installing nmap..")
        try:
            subprocess.run(
                ['winget', 'install', 'Insecure.Nmap'],
                check = True
            )
        except subprocess.CalledProcessError:
            print("Failed to install Nmap..")


def validate_network():

    try:
        urllib.request.urlopen("https://google.com, timeout=2")
    except (urllib.error.URLError, TimeoutError):
        print("Cannot establish network connection")
        sys.exit(1)


def target_list(subnet, submask, dir, timestamp):

    target = f"{subnet}/{mask}"
    output_file = f"{dir}/{timestamp}_scan.xml"

    command = ["nmap", -"-sP", target, "-oX", output_file]

    try:
        subprocess.run(command, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error: namp scan failed with exit code {e.returncode}")
