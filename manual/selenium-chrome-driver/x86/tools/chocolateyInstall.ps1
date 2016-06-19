$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$tmpDir = "$toolsDir\temp"

$packageArgs = @{
  packageName   = 'selenium-chrome-driver'
  url           = 'http://chromedriver.storage.googleapis.com/2.22/chromedriver_win32.zip'
  checksum      = 'c5962f884bd58987b1ef0fa04c6a3ce5'
  checksumType  = 'md5'
  unzipLocation  = $tmpDir	
}

Install-ChocolateyZipPackage @packageArgs

$binRoot = Get-BinRoot
$seleniumDir = "$binRoot\selenium"
$driverPath = "$seleniumDir\chromedriver.exe"

If (!(Test-Path -Path $seleniumDir)) {
  New-Item $seleniumDir -ItemType directory
}
Move-Item $tmpDir\chromedriver.exe $driverPath -Force
Remove-Item $tmpDir -Recurse -Force

$oldDriverPath = "$seleniumDir\chrome-driver.exe"
If (Test-Path -Path $oldDriverPath) {
  Remove-Item $oldDriverPath -Force
}

$menuPrograms = [environment]::GetFolderPath([environment+specialfolder]::Programs)
$shortcutArgs = @{
  shortcutFilePath = "$menuPrograms\Selenium\Selenium Chrome Driver.lnk"
  targetPath       = $driverPath
  iconLocation     = "$toolsDir\icon.ico"
}

Install-ChocolateyShortcut @shortcutArgs
