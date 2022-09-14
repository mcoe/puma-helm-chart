{{/*
Expand the name of the chart.
*/}}
{{- define "customsmanager.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "customsmanager.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "customsmanager.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "customsmanager.labels" -}}
helm.sh/chart: {{ include "customsmanager.chart" . }}
{{ include "customsmanager.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "customsmanager.selectorLabels" -}}
app.kubernetes.io/name: {{ include "customsmanager.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "customsmanager.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "customsmanager.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Define environment variables
*/}}
{{- define "customsmanager.list-env-variables" -}}
{{- range $val, $key := .Values.env.normal }}
- name: {{ $val }}
  value: {{ $key }}
{{- end}}
{{- range $val, $key := .Values.env.secret }}
- name: {{ $val }}
  valueFrom:
    secretKeyRef:
      name: customsmanager-env-var-secret
      key: {{ $key }}
{{- end}}
{{- end }}
