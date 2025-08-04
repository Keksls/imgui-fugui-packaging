# imgui-fugui-packaging

This repository provides a fully automated pipeline for building **ImGui.NET** bindings based on [cimgui](https://github.com/cimgui/cimgui) and [Dear ImGui](https://github.com/ocornut/imgui), with support for all major platforms (Windows, Linux, macOS), and additional **customizations** for the **Fugui** framework.

---

## 🧭 Purpose

This repo exists to:

- Build a **Fugui-compatible version** of `cimgui` + `imgui`
- Package native libraries (`.dll`, `.so`, `.dylib`) for Windows x64/x86/ARM64, Linux, and macOS
- Create a **NuGet package** for consumption by ImGui.NET
- Automatically trigger builds using **GitHub Actions**
- Maintain reproducibility via **forked and pinned submodules**

---

## 🔄 How to Clone

This project uses nested submodules pointing to **custom forks** with a specific branch (`fuguiBuild`).  
To clone it properly:

```bash
git clone --recurse-submodules https://github.com/keksls/imgui-fugui-packaging.git
cd imgui-fugui-packaging

# Optional (if submodules not initialized correctly)
git submodule update --init --recursive
```

If you already cloned without `--recurse-submodules`, fix it like this:

```bash
git submodule update --init cimgui
cd cimgui
git checkout fuguiBuild
git submodule update --init imgui
cd imgui
git checkout fuguiBuild
cd ../../
```

---

## 🌳 Why Use Forks and `fuguiBuild` Branches?

We use **custom forks** of both `cimgui` and `imgui` to:

- Add support for custom **assert handling** (`ImAssertHandler`)
- Fix issues specific to **ImGui.NET bindings**
- Apply changes required by the **Fugui** UI framework
- Ensure **long-term reproducibility**, even if upstream evolves

The `fuguiBuild` branches in each fork are **synchronized and locked**, so CI will always produce stable and known outputs.

---

## 🧱 Building Locally

### Prerequisites:

- Git (with submodule support)
- CMake
- A C compiler (e.g. MSVC, clang, or gcc)
- .NET 8 SDK
- Bash (on Windows, Git Bash is fine)

### Steps:

```bash
# Make sure you're in the project root
cd imgui-fugui-packaging

# Build native libraries and generate JSON files
./build-native.sh Release

# Build .NET package
dotnet pack -c Release ImGui.NET.SourceBuild.csproj
```

Resulting files:

- Native libs in `cimgui/build/...`
- NuGet package in `bin/Packages/Release/*.nupkg`

---

## 🤖 Building via GitHub Actions

Every push to the `main` branch triggers the CI workflow:

- Builds all platforms (Windows/Linux/macOS)
- Generates artifacts per platform
- Publishes a combined **`.zip`** with all native builds
- Generates `.nupkg` for publishing to NuGet or MyGet (if secrets are configured)

You can also trigger the workflow manually via the **Actions tab** with a custom `ReleaseType`.

Artifacts are uploaded automatically, including:
- `win-x64`, `win-x86`, `win-arm64`
- `ubuntu-latest`, `macos-latest`
- `JsonFiles` (for ImGui.NET generator)
- `.zip` containing **all binaries** (created manually in the release step)

---

## 🛠️ Modified Files and Features

### ✅ Custom Assert Handling

Added in `imgui`:

- `imgui_internal.h` and related files now include:
  ```cpp
  extern void (*ImAssertHandler)(const char* expr, const char* file, int line);
  ```

- All `IM_ASSERT` macros are replaced with calls to this handler, allowing integration with .NET’s `Debug.Assert`.

> 📁 See `imgui_fugui_assert_patch.diff` for exact changes (if maintained separately).

### ✅ Script Permissions

Scripts like `build-native.sh` and `ci-build.sh` are marked executable (`chmod +x`) to prevent CI failures.

### ✅ Shortening Paths on Windows

Some CI runners hit path length limits. To prevent this, the workflow moves the project to a short folder path (`./short/`) during the build.

---

## 📁 Folder Overview

```
.
├── .github/workflows/ci.yml       # GitHub Actions CI workflow
├── build-native.sh                # Native library builder (CMake)
├── ci-build.sh / ci-build.cmd     # Platform-specific CI wrappers
├── ImGui.NET.SourceBuild.csproj   # NuGet package project
├── cimgui/                        # Submodule (forked)
│   └── imgui/                     # Nested submodule (forked)
├── generator/                     # Outputs JSON for ImGui.NET
└── bin/Packages/Release/          # NuGet output
```

---

## 📦 Publishing NuGet (Optional)

If `MYGET_KEY` or `NUGET_KEY` secrets are configured in the GitHub repo:

- A push to `main` uploads untagged builds to **MyGet**
- A Git tag (e.g., `v1.91.6-fugui1`) creates a GitHub Release and uploads to **nuget.org**

---

## ❤️ Credits

- [ocornut/imgui](https://github.com/ocornut/imgui)
- [cimgui](https://github.com/cimgui/cimgui)
- [ImGui.NET](https://github.com/mellinoe/ImGui.NET)
- [Fugui](https://github.com/keksls/Fugui) – UI framework using these bindings

---

## ❓ Troubleshooting

- **Permission denied on `.sh` files**: run `chmod +x build-native.sh ci-build.sh`
- **Wrong submodule branch**: make sure both `cimgui` and `imgui` are on `fuguiBuild`
- **CI fails on clone**: avoid deep paths; Windows CI uses a `short/` directory

---

## 🗨️ Contact

Maintained by [@keksls](https://github.com/keksls) – feel free to open issues or PRs for compatibility or integration fixes.