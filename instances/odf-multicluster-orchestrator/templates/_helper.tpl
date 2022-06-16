{{- define "mirror.clusterRef" -}}
- clusterName: {{ .clusterName }}
  storageClusterRef:
    name: {{ include "mirror.storageCluster" . }}
    namespace: {{ include "mirror.storageNamespace" . }}
{{- end -}}

{{- define "mirror.storageCluster" -}}
{{ .storageCluster | default "ocs-storagecluster" }}
{{- end -}}

{{- define "mirror.storageNamespace" -}}
{{ .storageCluster | default "openshift-storage" }}
{{- end -}}