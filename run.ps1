param([int]$Port = 18080, [string]$JavaHome = $env:JAVA_HOME)
$ErrorActionPreference = 'Stop'
# 此脚本只负责下载和启动 Tomcat。学习代码都在 src/main/webapp 中。
$projectRoot = $PSScriptRoot
$version = '9.0.123'
$runtime = Join-Path $projectRoot '.runtime'
$tomcat = Join-Path $runtime "apache-tomcat-$version"

if (-not $JavaHome -or -not (Test-Path -LiteralPath (Join-Path $JavaHome 'bin\java.exe'))) {
    $jdk = Get-ChildItem -Path 'C:\Program Files\Java\jdk-*' -Directory -ErrorAction SilentlyContinue |
        Sort-Object Name -Descending | Select-Object -First 1
    if ($jdk) { $JavaHome = $jdk.FullName }
}
if (-not $JavaHome -or -not (Test-Path -LiteralPath (Join-Path $JavaHome 'bin\java.exe'))) {
    throw 'Install a JDK and set JAVA_HOME, or use: .\run.ps1 -JavaHome "your JDK folder"'
}
$env:JAVA_HOME = $JavaHome
Remove-Item Env:JRE_HOME -ErrorAction SilentlyContinue

if (-not (Test-Path -LiteralPath (Join-Path $tomcat 'bin\catalina.bat'))) {
    New-Item -ItemType Directory -Path $runtime -Force | Out-Null
    $zip = Join-Path $runtime "apache-tomcat-$version.zip"
    $url = "https://dlcdn.apache.org/tomcat/tomcat-9/v$version/bin/apache-tomcat-$version.zip"
    Write-Host 'Downloading Apache Tomcat (first run only)...'
    try { Invoke-WebRequest -Uri $url -OutFile $zip }
    catch {
        Invoke-WebRequest -Uri "https://archive.apache.org/dist/tomcat/tomcat-9/v$version/bin/apache-tomcat-$version.zip" -OutFile $zip
    }
    $expected = '79a498d57c8ac5d704aebd5c2ea0aa2adaa3fa7c75149d007f1e33bc7ce79a30240d774d807b6cf3a63a4228cad847785ccd960c841580a2ecab5b30e5d68422'
    if ((Get-FileHash -LiteralPath $zip -Algorithm SHA512).Hash -ne $expected) {
        throw 'Tomcat checksum mismatch. Please download again from the official website.'
    }
    Expand-Archive -LiteralPath $zip -DestinationPath $runtime -Force
}

# 只监听本机；把源代码目录直接部署为 /jsp-demo，修改 JSP 后刷新即可。
$serverFile = Join-Path $tomcat 'conf\server.xml'
[xml]$server = Get-Content -LiteralPath $serverFile -Raw
$server.Server.SetAttribute('port', '-1')
$connector = $server.SelectSingleNode('/Server/Service/Connector[@protocol="HTTP/1.1"]')
$connector.SetAttribute('port', [string]$Port)
$connector.SetAttribute('address', '127.0.0.1')
$server.Save($serverFile)
$contextDir = Join-Path $tomcat 'conf\Catalina\localhost'
New-Item -ItemType Directory -Path $contextDir -Force | Out-Null
$webapp = [System.Security.SecurityElement]::Escape((Join-Path $projectRoot 'src\main\webapp'))
Set-Content -LiteralPath (Join-Path $contextDir 'jsp-demo.xml') -Encoding UTF8 -Value "<Context docBase=`"$webapp`" />"
$env:CATALINA_HOME = $tomcat
$env:CATALINA_BASE = $tomcat
Write-Host "Open http://localhost:$Port/jsp-demo/objects"
Write-Host 'Press Ctrl+C to stop the server.'
& (Join-Path $tomcat 'bin\catalina.bat') run
