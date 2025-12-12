{ config, pkgs, ... }:

let
  # script SQL to initialize the database and user
  initSql = pkgs.writeText "mysql-init.sql" ''
    CREATE DATABASE IF NOT EXISTS appdb;
    CREATE USER IF NOT EXISTS 'app'@'%' IDENTIFIED BY 'apppass';
    GRANT ALL PRIVILEGES ON *.* TO 'app'@'%';
    FLUSH PRIVILEGES;
  '';
in
{
  # hostname of the container
  networking.hostName = "mysql-container";

  # expose the mysql port
  networking.firewall.allowedTCPPorts = [ 3306 ];

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;

    # configuration file, listen in all interfaces
    configFile = pkgs.writeText "my.cnf" ''
      [mysqld]
      datadir = /var/lib/mysql
      bind-address = 0.0.0.0
      port = 3306
    '';

    # exec the script and ensure the db is created
    ensureDatabases = [ "appdb" ];
    initialScript = initSql;
  };

  # useful pkgs inside the container
  environment.systemPackages = with pkgs; [
    mariadb
    vim
  ];
  system.stateVersion = "25.11";
}

