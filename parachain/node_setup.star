def run_testnet_node_with_entrypoint(plan, prometheus, image, chain_name, execute_command, rpc_port = None, prometheus_port = None, lib2lib_port = None):
    """
    Spawn a parachain node with specified configuration with entrypoint.

    Args:
        prometheus (bool): Boolean value to enable metrics for a given node.
        image (string): Docker image for the parachain node.
        chain_name (string): Name of the parachain.
        execute_command (list): Command to execute inside service.
        rpc_port (int, optional): The RPC port value. Defaults to None.
        prometheus_port (int, optional): The Prometheus port value. Defaults to None.
        lib2lib_port (int, optional): The lib2lib port value. Defaults to None.

    Returns:
        dict: The service details of spawned parachain node.
    """  
    ports = {
        "ws": PortSpec(9947, transport_protocol = "TCP"),
        "lib2lib": PortSpec(30333, transport_protocol = "TCP")
    }
    
    public_ports = {}

    if rpc_port != None :
        public_ports["ws"] = PortSpec(rpc_port, transport_protocol = "TCP")
    
    if lib2lib_port != None:
        public_ports["lib2lib"] = PortSpec(lib2lib_port, transport_protocol = "TCP")

    if prometheus:
        ports["metrics"] = PortSpec(9615, transport_protocol = "TCP", application_protocol = "http")
            
    if prometheus_port != None:
        public_ports["metrics"] = PortSpec(prometheus_port, transport_protocol = "TCP", application_protocol = "http")
    
    service_config = ServiceConfig(
        image = image,
        ports = ports,        
        public_ports = public_ports,
        files = {
            "/app": "configs",
        },
        entrypoint = execute_command,
    )
    parachain = plan.add_service(name = "{0}".format(chain_name), config = service_config)

    return parachain

def run_testnet_node_with_command(plan, prometheus, image, chain_name, execute_command, rpc_port = None, prometheus_port = None, lib2lib_port = None):
    """
    Spawn a parachain node with specified configuration with command.

    Args:
        prometheus (bool): Boolean value to enable metrics for a given node.
        image (string): Docker image for the parachain node.
        chain_name (string): Name of the parachain.
        execute_command (list): Command to execute inside service.
        rpc_port (int, optional): The RPC port value. Defaults to None.
        prometheus_port (int, optional): The Prometheus port value. Defaults to None.
        lib2lib_port (int, optional): The lib2lib port value. Defaults to None.

    Returns:
        dict: The service details of spawned parachain node.
    """
    ports = {
        "ws": PortSpec(9947, transport_protocol = "TCP"),
        "lib": PortSpec(30333)
    }

    public_ports = {}

    if rpc_port != None :
        public_ports["ws"] = PortSpec(rpc_port, transport_protocol = "TCP")
    
    if lib2lib_port != None:
        public_ports["lib"] = PortSpec(lib2lib_port, transport_protocol = "TCP")
        
    if prometheus:
        ports["metrics"] = PortSpec(9615, transport_protocol = "TCP", application_protocol = "http")
        
    if prometheus_port != None:
        public_ports["metrics"] = PortSpec(prometheus_port, transport_protocol = "TCP", application_protocol = "http")
    
    service_config = ServiceConfig(
        image = image,
        ports = ports,        
        public_ports = public_ports,
        files = {
            "/app": "configs",
        },
        cmd = execute_command,
    )
    parachain = plan.add_service(name = "{0}".format(chain_name), config = service_config)

    return parachain

def spawn_parachain(plan, prometheus, image, chain_name, execute_command, build_file, rpc_port = None, prometheus_port = None, lib2lib_port = None):
    """
    Spawn a parachain node with specified configuration.

    Args:
        prometheus (bool): Boolean value to enable metrics for a given node.
        image (string): Docker image for the parachain node.
        chain_name (string): Name of the parachain.
        execute_command (list): Command to execute inside service.
        build_file (string): Path to the build spec file.
        rpc_port (int, optional): The RPC port value. Defaults to None.
        prometheus_port (int, optional): The Prometheus port value. Defaults to None.
        lib2lib_port (int, optional): The lib2lib port value. Defaults to None.

    Returns:
        dict: The service details of spawned parachain node.
    """
    files = {
        "/app": "configs",
    }
    if build_file != None:
        files["/build"] = build_file
    
    ports = {
        "ws": PortSpec(9946, transport_protocol = "TCP", application_protocol = "http"),
        "lib2lib": PortSpec(30333, transport_protocol = "TCP", application_protocol = "http"),
    }

    public_ports = {}

    if rpc_port != None :
        public_ports["ws"] = PortSpec(rpc_port, transport_protocol = "TCP", application_protocol = "http")
    
    if lib2lib_port != None:
        public_ports["lib2lib"] = PortSpec(lib2lib_port, transport_protocol = "TCP", application_protocol = "http")
        
    if prometheus:
        ports["metrics"] = PortSpec(9615, transport_protocol = "TCP", application_protocol = "http")

    if prometheus_port != None:
        public_ports["metrics"] = PortSpec(prometheus_port, transport_protocol = "TCP", application_protocol = "http")
    
    parachain_node = plan.add_service(
        name = "{}".format(chain_name),
        config = ServiceConfig(
            image = image,
            files = files,
            ports = ports,
            public_ports = public_ports,
            entrypoint = execute_command,
        ),
    )

    return parachain_node
