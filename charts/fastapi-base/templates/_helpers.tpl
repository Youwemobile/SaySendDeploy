{{- define "fastapi-base.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Check if the service has secrets
*/}}
{{- define "fastapi-base.hasSecrets" -}}
  {{- if and .Values.secrets (gt (len .Values.secrets) 0) -}}
    {{- "true" -}}
  {{- else -}}
    {{- "false" -}}
  {{- end -}}
{{- end -}}
