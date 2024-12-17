# templates/_helpers.tpl
{{- define "minikubeIP" -}}
{{- if .Values.minikubeIP -}}
{{- .Values.minikubeIP -}}
{{- else -}}
{{- printf "$(minikube ip)" -}}
{{- end -}}
{{- end -}}