Vagrant.configure("2") do |config|
  # Base box configuration for Ubuntu 22.04 LTS
  config.vm.box = "ubuntu/jammy64" # Ubuntu 22.04 LTS

  # Master Node
  config.vm.define "locust-master" do |master|
    master.vm.hostname = "locust-master"
    master.vm.network "private_network", ip: "192.168.56.10"
    master.vm.provider "virtualbox" do |vb|
      vb.name = "Locust Master"
      vb.memory = "512"
      vb.customize ["modifyvm", :id, "--groups", "/locust"]
    end
    master.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update
      sudo apt-get install -y python3-pip
      pip3 install locust
      nohup locust --master --host=http://192.168.56.50 &
    SHELL
  end

  # Worker Nodes
  (1..3).each do |i|
    config.vm.define "locust-worker-#{i}" do |worker|
      worker.vm.hostname = "locust-worker-#{i}"
      worker.vm.network "private_network", ip: "192.168.56.1#{i}"
      worker.vm.provider "virtualbox" do |vb|
        vb.name = "Locust Worker #{i}"
        vb.memory = "512"
        vb.customize ["modifyvm", :id, "--groups", "/locust"]
      end
      worker.vm.provision "shell", inline: <<-SHELL
        sudo apt-get update
        sudo apt-get install -y python3-pip
        pip3 install locust
        nohup locust --worker --master-host=192.168.56.10 &
      SHELL
    end
  end

  # Target Server (Nginx)
  config.vm.define "target-server" do |server|
    server.vm.hostname = "target-server"
    server.vm.network "private_network", ip: "192.168.56.50"
    server.vm.provider "virtualbox" do |vb|
      vb.name = "Target Server"
      vb.memory = "512"
      vb.customize ["modifyvm", :id, "--groups", "/locust"]
    end
    server.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update
      sudo apt-get install -y nginx
      sudo systemctl enable nginx
      sudo systemctl start nginx
      echo "<h1>Welcome to the Nginx Target Server</h1>" | sudo tee /var/www/html/index.html
    SHELL
  end
end
