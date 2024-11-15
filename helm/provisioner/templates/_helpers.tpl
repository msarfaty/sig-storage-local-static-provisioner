{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "provisioner.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "provisioner.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "provisioner.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "provisioner.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "provisioner.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the image.
For backwards compatibility, older versions of the chart use string values for the image.
Newer standards usually allow users to specify the image separately (ie just the repository, or just the pull policy)
*/}}
{{- define "provisioner.image" -}}
{{- if (not (kindIs "string" .Values.image)) -}}
{{ printf "%s:%s" .Values.image.repository  (default (printf "v%s" .Chart.AppVersion) .Values.image.tag) }}
{{- else -}}
{{ .Values.image }}
{{- end -}}
{{- end -}}

{{/*
Create the image pullPolicy.
For backwards compatibility, there are two ways to set an image's pullPolicy (imagePullPolicy and image.pullPolicy)
If image is set as a map, we can assume that the user intends to use that pullPolicy
*/}}
{{- define "provisioner.image.pullPolicy" -}}
{{- if (and (kindIs "map" .Values.image) .Values.image.pullPolicy) -}}
{{ .Values.image.pullPolicy }}
{{- else if .Values.imagePullPolicy -}}
{{ .Values.imagePullPolicy }}
{{- end -}}
{{- end -}}