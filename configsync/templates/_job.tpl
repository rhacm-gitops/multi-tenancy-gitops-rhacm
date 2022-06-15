{{- define "certificates.gather" -}}
clusterSecret=$(oc get clusterdeployment {{ .name }} -n {{ .name }} -o jsonpath='{.spec.clusterMetadata.adminPasswordSecretRef.name}')
username=$(oc get secret $clusterSecret  -n {{ .name }} -o jsonpath="{.data.username}" | base64 --decode)
password=$(oc get secret $clusterSecret  -n {{ .name }} -o jsonpath="{.data.password}" | base64 --decode)
apiURL=$(oc get clusterdeployment -n {{ .name }} -o jsonpath="{.items[0].status.apiURL}")
export KUBECONFIG=/data/{{ .name }}-kubeconfig
oc login ${apiURL} -u ${username} -p ${password} --insecure-skip-tls-verify
oc get cm default-ingress-cert -n openshift-config-managed -o jsonpath="{['data']['ca-bundle\.crt']}" >> /data/{{ .name }}.crt
if oc get cm -n openshift-config user-ca-bundle > /dev/null 2>&1; then
  echo oc get cm -n openshift-config user-ca-bundle -o jsonpath="{['data']['ca-bundle\.crt']}" >> /data/{{ .name }}-existing-user-ca-bundle.crt || true
fi
unset KUBECONFIG
{{- end -}}

{{- define "certificates.sync" -}}
export KUBECONFIG=/data/{{ .name }}-kubeconfig
oc apply -f /data/combined-ca-bundle.yaml
oc patch proxy cluster --type=merge  --patch='{"spec":{"trustedCA":{"name":"user-ca-bundle"}}}'
unset KUBECONFIG
{{- end -}}

