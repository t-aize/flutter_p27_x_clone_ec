# Ouvrir l'adresse affichée dans Chrome habituel pour conserver les préférences.
Set-Location -LiteralPath (Split-Path -Parent $PSScriptRoot)
flutter run -d web-server --web-hostname localhost --web-port 55174
