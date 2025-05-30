frontend http-in
    bind *:80
    default_backend servers
backend servers
${backend_ips}
