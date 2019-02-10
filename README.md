# docker-webmin-samba

# Info
- Webmin
- Samba

# Docker
```
docker run  -d  
  -p 10000:10000 
  -p 137:137/udp 
  -p 138:138/udp 
  -p 139:139 
  -p 445:445 
  -h webmin.example.com 
  --name webmin 
  lukasmrtvy/docker-webmin-samba:latest
```

# Optional Variables
- WEBMIN_PASSWORD (default: admin)
- USE_SSL (default: true)
- BASE_URL (default: localhost)
- ALLOW_ONLY_SAMBA_RELATED_MODULES (default: true)
