<#
.SYNOPSIS
	Actualiza sincronización de directorios local y cloud.
.DESCRIPTION
	Actualiza sincronización de directorios, espera un tiempo prudencial y fuerza sincronización de AD Conect Delta
.EXAMPLE
	PS> ./Sync-AD-Entra.ps1 <ServerName>
  La sincronización se ejecutara en ServerName
  Sincronizando Active directory
  Iniciando sincronización Delta
  
  Completado
	...
.LINK
	https://github.com/lferrerfmv/PowerShell
.NOTES
	Author: Luis Ferrer | License: CC0
#>

# Comprovamos si disponemos de la información necesaria.
param(
    [Parameter()]
    [string]$Server = $ADSYNC_SERVER
)

# Validación básica
if (-not $Server) {
    Write-Error "Debes especificar el nombre del servidor o definir la variable ADSYNC_SERVER."
    exit 1
}


# Variables de entorno opcionales.
# $ADSYNC_SERVER = ""

# Silenciamos loa salida
$VerbosePreference = 'SilentlyContinue'

Write-Host "La sincronización se ejecutara en $server"

# Sincronización de directorios locales (para forzar repolicación entre sedes)
Write-Host "Sincronizando Active directory"
#repadmin /syncall /AeD

# Espera de periodo prudencial para garantizar sincronización
Start-Sleep -Seconds 3

# Ejecuta sincronización delta en AD Connect
Invoke-Command -ComputerName $Server -ScriptBlock {
    Write-Host "Iniciando sincronización Delta"
    Import-Module ADSync
    Start-ADSyncSyncCycle -PolicyType Delta
}
Start-Sleep -Seconds 1
Write-Host "Completado"

exit
