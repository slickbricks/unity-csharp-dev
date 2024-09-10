Here's a **`README.md`** file that explains how to set up the Docker environment for **Unity Hub** and **Visual Studio Code** with **.NET** and **C#** support, including the steps to enable software rendering for Unity Hub.

---

# Unity Hub and Visual Studio Code in Docker with .NET and C# Support

This repository sets up a Docker environment that includes Unity Hub, Visual Studio Code, and .NET SDK for C# development. The environment runs in a headless mode and uses software rendering to avoid requiring GPU access.

## Features

- **Unity Hub**: Manage and install different versions of the Unity Editor.
- **Visual Studio Code**: Development environment with C# support.
- **.NET SDK**: Support for C# development.
- **noVNC**: Access the environment via a browser using VNC.

## Prerequisites

Ensure you have Docker installed on your system. If not, you can follow the official Docker installation guide for your platform: https://docs.docker.com/get-docker/

## Building the Docker Image

1. Clone this repository to your local machine:
   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. Build the Docker image:
   ```bash
   docker build -t vscode-unity-dev .
   ```

## Running the Docker Container

To run the Docker container with Unity Hub in software rendering mode, execute the following command:

```bash
docker run --privileged -e LIBGL_ALWAYS_SOFTWARE=1 -p 6080:6080 -p 5901:5901 -d vscode-unity-dev
```

### Explanation of Command:
- `--privileged`: Grants the container the necessary permissions for FUSE.
- `-e LIBGL_ALWAYS_SOFTWARE=1`: Forces Unity Hub to use software rendering instead of looking for a GPU.
- `-p 6080:6080 -p 5901:5901`: Exposes ports for VNC and noVNC, enabling remote access to the Unity environment.

## Accessing the Environment

1. **noVNC (Web Access)**:
   - Open your browser and navigate to `http://localhost:6080` to access the container's desktop environment.

2. **VNC Viewer**:
   - You can also connect using a VNC viewer at `localhost:5901`.

## Launching Unity Hub

Once inside the container, you can launch Unity Hub from the terminal:

```bash
/usr/local/bin/unityhub
```

Unity Hub will open, allowing you to manage and install Unity Editors. Ensure you log in with your Unity account and activate the license.

## Using Visual Studio Code for C# Development

1. **Open Visual Studio Code**:
   - In the terminal, you can run:
     ```bash
     code
     ```
   - This will launch Visual Studio Code with installed extensions for C# and .NET development.

2. **.NET C# Development**:
   - The .NET SDK is installed, and you can create a new C# project with the following command:
     ```bash
     dotnet new console -n MyConsoleApp
     ```

## License Activation for Unity

### Option 1: Using the Login Screen (GUI)
Log into Unity Hub through the GUI when prompted. If you encounter rendering issues, ensure that `LIBGL_ALWAYS_SOFTWARE=1` is set for software rendering.

### Option 2: Offline License Activation
If you need to activate Unity offline, follow these steps:

1. **Generate a License Request File**:
   ```bash
   unityhub --headless --create-log --license-request
   ```

2. **Upload the License Request**:
   Visit [Unity's license activation page](https://license.unity3d.com/manual) to upload the `.alf` file and get a `.ulf` license file.

3. **Activate the License**:
   ```bash
   unityhub --headless --create-log --manual-license-file <path-to-ulf-file>
   ```

## Notes

- **Software Rendering**: Running Unity Hub with `LIBGL_ALWAYS_SOFTWARE=1` enables software rendering through Mesa, which is useful in environments without GPU access.
- **Licensing**: Unity requires a valid license to run. Make sure you log in to Unity Hub and activate your license.

## Troubleshooting

- **White Screen on Unity Hub**: If the Unity Hub login screen flashes and turns white, ensure you are using software rendering with `LIBGL_ALWAYS_SOFTWARE=1`.
- **License Issues**: If you're unable to log in via the GUI, consider using the manual license activation method described above.

## References

- [Unity Hub Documentation](https://docs.unity3d.com/Manual/GettingStartedHub.html)
- [Docker Documentation](https://docs.docker.com/)

---

This **`README.md`** provides detailed instructions for setting up and running Unity Hub and Visual Studio Code inside the Docker container. If you have additional customization or instructions specific to your environment, feel free to modify it as needed.