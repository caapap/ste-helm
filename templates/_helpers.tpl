{{/*
# Copyright 2024 kxdigit | 讯飞数码
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
*/}}
{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "stellar.name" -}}
{{- default "ste" .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "stellar.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "stellar" .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/* Helm required labels */}}
{{- define "stellar.labels" -}}
heritage: {{ .Release.Service }}
release: {{ .Release.Name }}
chart: {{ .Chart.Name }}
app: "{{ template "stellar.name" . }}"
{{- end -}}

{{/* matchLabels */}}
{{- define "stellar.matchLabels" -}}
release: {{ .Release.Name }}
app: "{{ template "stellar.name" . }}"
{{- end -}}

{{- define "stellar.autoGenCert" -}}
  {{- if and .Values.expose.tls.enabled (eq .Values.expose.tls.certSource "auto") -}}
    {{- printf "true" -}}
  {{- else -}}
    {{- printf "false" -}}
  {{- end -}}
{{- end -}}

{{- define "stellar.autoGenCertForIngress" -}}
  {{- if and (eq (include "stellar.autoGenCert" .) "true") (eq .Values.expose.type "ingress") -}}
    {{- printf "true" -}}
  {{- else -}}
    {{- printf "false" -}}
  {{- end -}}
{{- end -}}

{{- define "stellar.autoGenCertForNginx" -}}
  {{- if and (eq (include "stellar.autoGenCert" .) "true") (ne .Values.expose.type "ingress") -}}
    {{- printf "true" -}}
  {{- else -}}
    {{- printf "false" -}}
  {{- end -}}
{{- end -}}

{{- define "stellar.database.host" -}}
  {{- if eq .Values.database.type "internal" -}}
    {{- template "stellar.database" . }}
  {{- else -}}
    {{- .Values.database.external.host -}}
  {{- end -}}
{{- end -}}

{{- define "stellar.database.port" -}}
  {{- if eq .Values.database.type "internal" -}}
    {{- printf "%s" "3306" -}}
  {{- else -}}
    {{- .Values.database.external.port -}}
  {{- end -}}
{{- end -}}

{{- define "stellar.database.servicePort" -}}
    {{- template "stellar.database.port" . }}
{{- end -}}

{{- define "stellar.database.username" -}}
  {{- if eq .Values.database.type "internal" -}}
    {{- .Values.database.internal.username -}}
  {{- else -}}
    {{- .Values.database.external.username -}}
  {{- end -}}
{{- end -}}

{{- define "stellar.database.rawPassword" -}}
  {{- if eq .Values.database.type "internal" -}}
    {{- .Values.database.internal.password -}}
  {{- else -}}
    {{- .Values.database.external.password -}}
  {{- end -}}
{{- end -}}

{{- define "stellar.database.name" -}}
  {{- if eq .Values.database.type "internal" -}}
    {{- printf "%s" "ste_v2" -}}
  {{- else -}}
    {{- .Values.database.external.name -}}
  {{- end -}}
{{- end -}}

{{- define "stellar.database.escapedRawPassword" -}}
  {{- include "stellar.database.rawPassword" . | urlquery | replace "+" "%20" -}}
{{- end -}}

{{- define "stellar.database.encryptedPassword" -}}
  {{- include "stellar.database.rawPassword" . | b64enc | quote -}}
{{- end -}}

{{- define "stellar.database.sslmode" -}}
  {{- if eq .Values.database.type "internal" -}}
    {{- printf "%s" "disable" -}}
  {{- else -}}
    {{- .Values.database.external.sslmode -}}
  {{- end -}}
{{- end -}}

{{- define "stellar.ste.host" -}}
  {{- if eq .Values.ste.type "internal" -}}
    {{- template "stellar.ste" . }}
  {{- else -}}
    {{- .Values.ste.external.host -}}
  {{- end -}}
{{- end -}}


{{- define "stellar.ste.port" -}}
  {{- if eq .Values.ste.type "internal" -}}
    {{- printf "%s" "17000" -}}
  {{- else -}}
    {{- .Values.ste.external.port -}}
  {{- end -}}
{{- end -}}

{{- define "stellar.ste.servicePort" -}}
    {{- printf "80" -}}
{{- end -}}

{{- define "stellar.ste.ibexPort" -}}
  {{- if eq .Values.ste.type "internal" -}}
    {{- printf "%s" "20090" -}}
  {{- else -}}
    {{- .Values.ste.external.ibexPort -}}
  {{- end -}}
{{- end -}}

{{- define "stellar.ste.ibexServicePort" -}}
    {{- printf "20090" -}}
{{- end -}}

{{- define "stellar.prometheus.host" -}}
  {{- if eq .Values.prometheus.type "internal" -}}
    {{- template "stellar.prometheus" . }}
  {{- else -}}
    {{- .Values.prometheus.external.host -}}
  {{- end -}}
{{- end -}}

{{- define "stellar.prometheus.port" -}}
  {{- if eq .Values.prometheus.type "internal" -}}
    {{- printf "%s" "9090" -}}
  {{- else -}}
    {{- .Values.prometheus.external.port -}}
  {{- end -}}
{{- end -}}

{{- define "stellar.prometheus.servicePort" -}}
  {{- template "stellar.prometheus.port" . }}
{{- end -}}

{{- define "stellar.prometheus.username" -}}
  {{- if eq .Values.prometheus.type "internal" -}}
    {{- .Values.prometheus.internal.username -}}
  {{- else -}}
    {{- .Values.prometheus.external.username -}}
  {{- end -}}
{{- end -}}

{{- define "stellar.prometheus.rawPassword" -}}
  {{- if eq .Values.prometheus.type "internal" -}}
    {{- .Values.prometheus.internal.password -}}
  {{- else -}}
    {{- .Values.prometheus.external.password -}}
  {{- end -}}
{{- end -}}

{{- define "stellar.redis.scheme" -}}
  {{- with .Values.redis }}
    {{- ternary "redis+sentinel" "redis"  (and (eq .type "external" ) (not (not .external.sentinelMasterSet))) }}
  {{- end }}
{{- end -}}

/*host:port*/
{{- define "stellar.redis.addr" -}}
  {{- with .Values.redis }}
    {{- ternary (printf "%s:6379" (include "stellar.redis" $ )) .external.addr (eq .type "internal") }}
  {{- end }}
{{- end -}}

{{- define "stellar.redis.masterSet" -}}
  {{- with .Values.redis }}
    {{- ternary .external.sentinelMasterSet "" (eq "redis+sentinel" (include "stellar.redis.scheme" $)) }}
  {{- end }}
{{- end -}}

{{- define "stellar.redis.password" -}}
  {{- with .Values.redis }}
    {{- ternary "" .external.password (eq .type "internal") }}
  {{- end }}
{{- end -}}

{{- define "stellar.redis.mode" -}}
  {{- with .Values.redis }}
    {{- ternary "standalone" .external.mode (eq .type "internal") }}
  {{- end }}
{{- end -}}

/*scheme://[redis:password@]host:port[/master_set]*/
{{- define "stellar.redis.url" -}}
  {{- with .Values.redis }}
    {{- $path := ternary "" (printf "/%s" (include "stellar.redis.masterSet" $)) (not (include "stellar.redis.masterSet" $)) }}
    {{- $cred := ternary (printf "redis:%s@" (.external.password | urlquery)) "" (and (eq .type "external" ) (not (not .external.password))) }}
    {{- printf "%s://%s%s%s" (include "stellar.redis.scheme" $) $cred (include "stellar.redis.addr" $) $path -}}
  {{- end }}
{{- end -}}

{{- define "stellar.redis" -}}
  {{- printf "%s-redis" (include "stellar.fullname" .) -}}
{{- end -}}

{{- define "stellar.database" -}}
  {{- printf "%s-database" (include "stellar.fullname" .) -}}
{{- end -}}

{{- define "stellar.prometheus" -}}
  {{- printf "%s-prometheus" (include "stellar.fullname" .) -}}
{{- end -}}

{{- define "stellar.categraf" -}}
  {{- printf "%s-categraf-v6" (include "stellar.fullname" .) -}}
{{- end -}}

{{- define "stellar.ste" -}}
  {{- printf "%s-center" (include "stellar.fullname" .) -}}
{{- end -}}

{{- define "stellar.nginx" -}}
  {{- printf "%s-nginx" (include "stellar.fullname" .) -}}
{{- end -}}

{{- define "stellar.ingress" -}}
  {{- printf "%s-ingress" (include "stellar.fullname" .) -}}
{{- end -}}

{{- define "stellar.caBundleVolume" -}}
- name: ca-bundle-certs
  secret:
    secretName: {{ .Values.caBundleSecretName }}
{{- end -}}

{{- define "stellar.caBundleVolumeMount" -}}
- name: ca-bundle-certs
  mountPath: /stellar_cust_cert/custom-ca.crt
  subPath: ca.crt
{{- end -}}

{{/* now it only support http mode */}}
{{- define "stellar.component.scheme" -}}
    {{- printf "http" -}}
{{- end -}}


{{- define "stellar.tlsSecretForIngress" -}}
  {{- if eq .Values.expose.tls.certSource "none" -}}
    {{- printf "" -}}
  {{- else if eq .Values.expose.tls.certSource "secret" -}}
    {{- .Values.expose.tls.secret.secretName -}}
  {{- else -}}
    {{- include "stellar.ingress" . -}}
  {{- end -}}
{{- end -}}

{{- define "stellar.tlsSecretForNginx" -}}
  {{- if eq .Values.expose.tls.certSource "secret" -}}
    {{- .Values.expose.tls.secret.secretName -}}
  {{- else -}}
    {{- include "stellar.nginx" . -}}
  {{- end -}}
{{- end -}}

{{/* Allow KubeVersion to be overridden. */}}
{{- define "stellar.ingress.kubeVersion" -}}
  {{- default .Capabilities.KubeVersion.Version .Values.expose.ingress.kubeVersionOverride -}}
{{- end -}}
