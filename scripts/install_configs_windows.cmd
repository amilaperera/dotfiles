@echo off
REM ============================================================================
REM install_configs_windows.cmd
REM ============================================================================
REM
REM PURPOSE:
REM   This script copies Neovim and WezTerm configurations from the dotfiles
REM   repository to the appropriate Windows user locations.
REM
REM LOCATIONS:
REM   - Neovim config:  %LOCALAPPDATA%\nvim\       (e.g., C:\Users\<user>\AppData\Local\nvim)
REM   - WezTerm config: %USERPROFILE%\.wezterm.lua (e.g., C:\Users\<user>\.wezterm.lua)
REM
REM USAGE:
REM   1. Open Command Prompt or PowerShell
REM   2. Navigate to the scripts directory in your dotfiles
REM   3. Run: install_configs_windows.cmd
REM
REM   Or run directly from anywhere:
REM      C:\path\to\dotfiles\scripts\install_configs_windows.cmd
REM
REM REQUIREMENTS:
REM   - Windows 10 or later
REM   - The dotfiles repository should be cloned/available on Windows
REM   - Run from within the dotfiles repository structure
REM
REM AUTHOR: Amila Perera
REM ============================================================================

setlocal EnableDelayedExpansion

REM ----------------------------------------------------------------------------
REM CONFIGURATION - Define color codes for output formatting
REM ----------------------------------------------------------------------------
REM Note: Windows CMD doesn't natively support ANSI colors in older versions,
REM but Windows 10+ Terminal and modern CMD support them.

REM ----------------------------------------------------------------------------
REM HELPER FUNCTIONS - Subroutines for common operations
REM ----------------------------------------------------------------------------

REM Print a header banner to make output readable
echo.
echo ============================================================================
echo   Dotfiles Configuration Installer for Windows
echo ============================================================================
echo.

REM ----------------------------------------------------------------------------
REM STEP 1: Determine the script's location and repository root
REM ----------------------------------------------------------------------------
REM %~dp0 gives us the drive and path of this script (the scripts\ directory)
REM We go one level up to get the dotfiles root directory

set "SCRIPT_DIR=%~dp0"

REM Remove trailing backslash if present for cleaner path handling
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

REM Navigate up one level to get the dotfiles root
REM (assumes script is in dotfiles\scripts\)
for %%i in ("%SCRIPT_DIR%") do set "DOTFILES_ROOT=%%~dpi"

REM Remove trailing backslash
if "%DOTFILES_ROOT:~-1%"=="\" set "DOTFILES_ROOT=%DOTFILES_ROOT:~0,-1%"

echo [INFO] Script directory:   %SCRIPT_DIR%
echo [INFO] Dotfiles root:      %DOTFILES_ROOT%
echo.

REM ----------------------------------------------------------------------------
REM STEP 2: Define source and destination paths
REM ----------------------------------------------------------------------------

REM Source paths (where configs live in the dotfiles repo)
set "NVIM_SOURCE=%DOTFILES_ROOT%\config\nvim"
set "WEZTERM_SOURCE=%DOTFILES_ROOT%\config\wezterm\.wezterm.lua"
set "WALLPAPERS_SOURCE=%DOTFILES_ROOT%\wallpapers"

REM Destination paths (where Windows expects these configs)
REM   - Neovim: %LOCALAPPDATA%\nvim (standard Windows Neovim config location)
REM   - WezTerm: %USERPROFILE%\.wezterm.lua (WezTerm looks in home directory)
REM   - Wallpapers: %USERPROFILE%\wallpapers (for wezterm background)
set "NVIM_DEST=%LOCALAPPDATA%\nvim"
set "WEZTERM_DEST=%USERPROFILE%\.wezterm.lua"
set "WALLPAPERS_DEST=%USERPROFILE%\wallpapers"

echo [INFO] Source Paths:
echo        Neovim:     %NVIM_SOURCE%
echo        WezTerm:    %WEZTERM_SOURCE%
echo        Wallpapers: %WALLPAPERS_SOURCE%
echo.
echo [INFO] Destination Paths:
echo        Neovim:     %NVIM_DEST%
echo        WezTerm:    %WEZTERM_DEST%
echo        Wallpapers: %WALLPAPERS_DEST%
echo.

REM ----------------------------------------------------------------------------
REM STEP 3: Validate source paths exist
REM ----------------------------------------------------------------------------
echo [STEP] Validating source paths...

if not exist "%NVIM_SOURCE%" (
    echo [ERROR] Neovim config source not found: %NVIM_SOURCE%
    echo         Please ensure you are running this from the correct dotfiles location.
    goto :error
)
echo        [OK] Neovim source exists

if not exist "%WEZTERM_SOURCE%" (
    echo [ERROR] WezTerm config source not found: %WEZTERM_SOURCE%
    echo         Please ensure you are running this from the correct dotfiles location.
    goto :error
)
echo        [OK] WezTerm source exists

if not exist "%WALLPAPERS_SOURCE%" (
    echo [WARN] Wallpapers directory not found: %WALLPAPERS_SOURCE%
    echo        WezTerm background may not work correctly.
) else (
    echo        [OK] Wallpapers source exists
)

echo.

REM ----------------------------------------------------------------------------
REM STEP 4: Copy wallpapers for WezTerm background
REM ----------------------------------------------------------------------------
REM The wezterm config references ~/wallpapers/wallpaper2.png
REM On Windows, this translates to %USERPROFILE%\wallpapers\
REM We copy the wallpapers directory so wezterm can find them

echo [STEP] Copying wallpapers for WezTerm background...

if exist "%WALLPAPERS_SOURCE%" (
    REM Remove existing wallpapers directory if present (always replace)
    if exist "%WALLPAPERS_DEST%" (
        echo        [INFO] Removing existing wallpapers at %WALLPAPERS_DEST%
        rd /s /q "%WALLPAPERS_DEST%" 2>nul
    )

    REM Copy wallpapers directory
    xcopy "%WALLPAPERS_SOURCE%" "%WALLPAPERS_DEST%" /E /I /H /Y >nul
    if errorlevel 1 (
        echo        [WARN] Failed to copy wallpapers. WezTerm background may not work.
    ) else (
        echo        [OK] Copied wallpapers to %WALLPAPERS_DEST%
    )
) else (
    echo        [WARN] Wallpapers source not found. Skipping wallpaper copy.
)

echo.

REM ----------------------------------------------------------------------------
REM STEP 5: Install Neovim configuration
REM ----------------------------------------------------------------------------
REM Neovim on Windows looks for config in %LOCALAPPDATA%\nvim\
REM We'll create a directory junction to avoid copying files (allows easy updates)

echo [STEP] Installing Neovim configuration...

REM Ensure parent directory exists
if not exist "%LOCALAPPDATA%" (
    echo [ERROR] LOCALAPPDATA directory not found. Is this Windows?
    goto :error
)

REM Check if nvim config already exists
if exist "%NVIM_DEST%" (
    echo        [INFO] Existing Neovim config found at %NVIM_DEST%

    REM Prompt user for action
    echo.
    set /p "NVIM_CHOICE=        Do you want to replace it? [y/N]: "

    if /i "!NVIM_CHOICE!"=="y" (
        echo        [INFO] Removing existing Neovim config...

        REM Try to remove as junction first, then as directory
        rmdir "%NVIM_DEST%" 2>nul
        if exist "%NVIM_DEST%" (
            REM It's a real directory, remove recursively
            rd /s /q "%NVIM_DEST%" 2>nul
            if exist "%NVIM_DEST%" (
                echo        [ERROR] Could not remove existing config directory.
                echo                Please manually remove: %NVIM_DEST%
                goto :error
            )
        )
        echo        [OK] Removed existing config
    ) else (
        echo        [SKIP] Keeping existing Neovim config
        goto :skip_nvim
    )
)

REM Create directory junction to nvim config
REM Using junction (/J) instead of symlink (/D) as it doesn't require admin rights
mklink /J "%NVIM_DEST%" "%NVIM_SOURCE%" >nul 2>&1
if errorlevel 1 (
    echo        [WARN] Junction creation failed. Trying symlink (may need admin)...
    mklink /D "%NVIM_DEST%" "%NVIM_SOURCE%" >nul 2>&1
    if errorlevel 1 (
        echo        [WARN] Symlink failed. Falling back to copying files...
        xcopy "%NVIM_SOURCE%" "%NVIM_DEST%" /E /I /H /Y >nul
        if errorlevel 1 (
            echo        [ERROR] Failed to copy Neovim configuration.
            goto :error
        )
        echo        [OK] Copied Neovim config (note: updates require re-running this script)
    ) else (
        echo        [OK] Created Neovim config symlink
    )
) else (
    echo        [OK] Created Neovim config junction (auto-updates with dotfiles)
)

:skip_nvim
echo.

REM ----------------------------------------------------------------------------
REM STEP 6: Install WezTerm configuration
REM ----------------------------------------------------------------------------
REM WezTerm looks for .wezterm.lua in the user's home directory (%USERPROFILE%)
REM This is a single file - we copy it directly (symlinks don't work reliably)

echo [STEP] Installing WezTerm configuration...

REM Remove existing config if present (always overwrite)
if exist "%WEZTERM_DEST%" (
    echo        [INFO] Removing existing WezTerm config at %WEZTERM_DEST%
    del /f "%WEZTERM_DEST%" 2>nul
    if exist "%WEZTERM_DEST%" (
        echo        [ERROR] Could not remove existing config file.
        echo                Please manually remove: %WEZTERM_DEST%
        goto :error
    )
)

REM Copy wezterm config file (overwrite mode)
copy /y "%WEZTERM_SOURCE%" "%WEZTERM_DEST%" >nul
if errorlevel 1 (
    echo        [ERROR] Failed to copy WezTerm configuration.
    goto :error
)
echo        [OK] Copied WezTerm config to %WEZTERM_DEST%

:skip_wezterm
echo.

REM ----------------------------------------------------------------------------
REM STEP 7: Summary and completion
REM ----------------------------------------------------------------------------
echo ============================================================================
echo   Installation Complete!
echo ============================================================================
echo.
echo   Installed configurations:
echo.
echo   [Neovim]
echo     Source:      %NVIM_SOURCE%
echo     Destination: %NVIM_DEST%
echo.
echo   [WezTerm]
echo     Source:      %WEZTERM_SOURCE%
echo     Destination: %WEZTERM_DEST%
echo.
echo   [Wallpapers]
echo     Source:      %WALLPAPERS_SOURCE%
echo     Destination: %WALLPAPERS_DEST%
echo.
echo   NOTES:
echo   - Neovim config uses junction/symlink, changes to dotfiles auto-sync
echo   - WezTerm config and wallpapers are copied, re-run script to update
echo   - Font "Hack Nerd Font Mono" must be installed for proper rendering
echo.
echo   Recommended next steps:
echo   1. Install Hack Nerd Font: https://www.nerdfonts.com/
echo   2. Restart WezTerm to apply changes
echo   3. Open Neovim to trigger plugin installation
echo.
echo ============================================================================

goto :end

REM ----------------------------------------------------------------------------
REM ERROR HANDLING
REM ----------------------------------------------------------------------------
:error
echo.
echo ============================================================================
echo   [ERROR] Installation failed!
echo ============================================================================
echo.
echo   Please check the error messages above and try again.
echo   Common issues:
echo   - Script not run from within the dotfiles repository
echo   - Missing source configuration files
echo   - Need administrator privileges for symlinks
echo.
endlocal
exit /b 1

REM ----------------------------------------------------------------------------
REM CLEAN EXIT
REM ----------------------------------------------------------------------------
:end
endlocal
exit /b 0
