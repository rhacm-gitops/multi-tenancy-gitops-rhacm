{{- define "cluster.login" -}}
clusterSecret=$(oc get clusterdeployment {{ .name }} -n {{ .name }} -o jsonpath='{.spec.clusterMetadata.adminPasswordSecretRef.name}')
username=$(oc get secret $clusterSecret  -n {{ .name }} -o jsonpath="{.data.username}" | base64 --decode)
password=$(oc get secret $clusterSecret  -n {{ .name }} -o jsonpath="{.data.password}" | base64 --decode)
apiURL=$(oc get clusterdeployment -n {{ .name }} -o jsonpath="{.items[0].status.apiURL}")
oc login ${apiURL} -u ${username} -p ${password} --insecure-skip-tls-verify
{{- end -}}


# hack
{{- define "primaryClusters" -}}
{{ $myList := list }}
{{- range $idx, $cluster := .Values.clusters -}}
{{- if eq .role "primary" -}}
{{ $myList = append $myList .name }}
{{- end -}}
{{- end -}}
{{ $myList | first }}
{{- end -}}

# hack
{{- define "secondaryClusters" -}}
{{ $myList := list }}
{{- range $idx, $cluster := .Values.clusters -}}
{{- if eq .role "secondary" -}}
{{ $myList = append $myList .name }}
{{- end -}}
{{- end -}}
{{ $myList | first}}
{{- end -}}
