; Script generated by the ASCOM Driver Installer Script Generator 6.2.0.0
; Generated by Robert Morgan on 5/20/2018 (UTC)
#define MyAppName "GSServer"
#define MyAppExeName "GS.Server.exe"

[Setup]
AppVerName=ASCOM GS Server 1.0.0.14
AppVersion=1.0.0.14
VersionInfoVersion=1.0.0.14
OutputBaseFilename="ASCOMGSServer10014Setup"
AppID={{0ff78bd6-6149-4536-9252-3da68b94f7c2}
AppName=GS Server
AppPublisher=Robert Morgan <robert.morgan.e@gmail.com>
AppPublisherURL=mailto:robert.morgan.e@gmail.com
AppSupportURL=https://ascomtalk.groups.io/g/Developer/topics
AppUpdatesURL=http://ascom-standards.org/
MinVersion=0,6.1
DefaultDirName="{cf}\ASCOM\Telescope\GSServer"
DefaultGroupName="GS Server"
DisableDirPage=yes
DisableProgramGroupPage=yes
OutputDir="."
Compression=lzma
SetupIconFile="C:\Users\Rob\source\repos\GSSolution\Resources\Installer\greenswamp2.ico"
SolidCompression=yes
; Put there by Platform if Driver Installer Support selected
WizardImageFile="C:\Users\Rob\source\repos\GSSolution\Resources\Installer\WizardImage1.bmp"
LicenseFile="C:\Users\Rob\source\repos\GSSolution\Resources\Installer\License.txt"
; {cf}\ASCOM\Uninstall\Telescope folder created by Platform, always
UninstallFilesDir="{cf}\ASCOM\Uninstall\Telescope\GSServer"

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Dirs]
Name: "{cf}\ASCOM\Uninstall\Telescope\GSServer\"
Name: "{cf}\ASCOM\Uninstall\Telescope\GSServer\Drivers\"
Name: "{cf}\ASCOM\Uninstall\Telescope\GSServer\Drivers\SkyScripts\"
Name: "{cf}\ASCOM\Uninstall\Telescope\GSServer\NotesTemplates\"
; TODO: Add subfolders below {app} as needed (e.g. Name: "{app}\MyFolder")

[Files]
Source: "C:\Users\Rob\source\repos\GSSolution\Builds\Release\*.*"; DestDir: "{app}"
Source: "C:\Users\Rob\source\repos\GSSolution\Builds\Release\Drivers\*.*"; DestDir: "{app}\Drivers";
Source: "C:\Users\Rob\source\repos\GSSolution\Builds\Release\Drivers\SkyScripts\*.*"; DestDir: "{app}\SkyScripts";
Source: "C:\Users\Rob\source\repos\GSSolution\Builds\Debug\Notes\NotesTemplates\*.*"; DestDir: "{app}\NotesTemplates";
; Require a read-me to appear after installation, maybe driver's Help doc
Source: "C:\Users\Rob\source\repos\GSSolution\Resources\Manuals\GSS Manual.pdf"; DestDir: "{app}"; Flags: isreadme
; TODO: Add other files needed by your driver here (add subfolders above)

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; \
    GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Icons]
Name: "{group}\GS Server"; Filename: "{app}\GS.Server.exe"
Name: "{group}\GS Manual"; Filename: "{app}\GSS Manual.pdf"
Name: "{userdesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

; Only if driver is .NET
[Run]

; Only for .NET local-server drivers
Filename: "{app}\GS.Server.exe"; Parameters: "/register"

; Only if driver is .NET
[UninstallRun]
; This helps to give a clean uninstall

; Only for .NET local-server drivers, use /unprofile to remove ascom profile 
Filename: "{app}\GS.Server.exe"; Parameters: "/unregister /unprofile"

[CODE]
//
// Before the installer UI appears, verify that the (prerequisite)
// ASCOM Platform 6.4 or greater is installed, including both Helper
// components. Utility is required for all types (COM and .NET)!
//
function InitializeSetup(): Boolean;
var
   U: Variant;
   H: Variant;
begin
   Result := FALSE;  // Assume failure
   // check that the DriverHelper and Utilities objects exist, report errors if they don't
   try
      H := CreateOleObject('DriverHelper.Util');
   except
      MsgBox('The ASCOM DriverHelper object has failed to load, this indicates a serious problem with the ASCOM installation', mbInformation, MB_OK);
   end;
   try
      U := CreateOleObject('ASCOM.Utilities.Util');
   except
      MsgBox('The ASCOM Utilities object has failed to load, this indicates that the ASCOM Platform has not been installed correctly', mbInformation, MB_OK);
   end;
   try
      if (U.IsMinimumRequiredVersion(6,4)) then	// this will work in all locales
         Result := TRUE;
   except
   end;
   if(not Result) then
      MsgBox('The ASCOM Platform 6.4 or greater is required for this driver.', mbInformation, MB_OK);
end;

// Code to enable the installer to uninstall previous versions of itself when a new version is installed
procedure CurStepChanged(CurStep: TSetupStep);
var
  ResultCode: Integer;
  UninstallExe: String;
  UninstallRegistry: String;
begin
  if (CurStep = ssInstall) then // Install step has started
	begin
      // Create the correct registry location name, which is based on the AppId
      UninstallRegistry := ExpandConstant('Software\Microsoft\Windows\CurrentVersion\Uninstall\{#SetupSetting("AppId")}' + '_is1');
      // Check whether an extry exists
      if RegQueryStringValue(HKLM, UninstallRegistry, 'UninstallString', UninstallExe) then
        begin // Entry exists and previous version is installed so run its uninstaller quietly after informing the user
          MsgBox('Setup will now remove the previous version.', mbInformation, MB_OK);
          Exec(RemoveQuotes(UninstallExe), ' /SILENT', '', SW_SHOWNORMAL, ewWaitUntilTerminated, ResultCode);
          sleep(1000);    //Give enough time for the install screen to be repainted before continuing
        end
  end;
end;