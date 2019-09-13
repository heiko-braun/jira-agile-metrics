container: 
    volumeMounts:
        - mountPath: /data
        name: metrics-data
volumes:        
    - name: metrics-data
      persistentVolumeClaim:
        claimName: metrics-data