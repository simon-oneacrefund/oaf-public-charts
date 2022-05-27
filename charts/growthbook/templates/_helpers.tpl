{{/*
Expand the name of the chart.
*/}}
{{- define "growthbook.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "growthbook.fullname" -}}
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
{{- define "growthbook.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "growthbook.labels" -}}
helm.sh/chart: {{ include "growthbook.chart" . }}
{{ include "growthbook.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "growthbook.selectorLabels" -}}
app.kubernetes.io/name: {{ include "growthbook.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "growthbook.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "growthbook.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* PVC existing, emptyDir, Dynamic */}}
{{- define "growthbook.pvc" -}}
{{- if or (not .Values.persistence.enabled) (eq .Values.persistence.type "emptyDir") -}}
          emptyDir: {}
{{- else if and .Values.persistence.enabled .Values.persistence.existingClaim -}}
          persistentVolumeClaim:
            claimName: {{ .Values.persistence.existingClaim }}
{{- else if and .Values.persistence.enabled (eq .Values.persistence.type "dynamic")  -}}
          persistentVolumeClaim:
            claimName: {{ include "growthbook.fullname" . }}
{{- end }}
{{- end }}
