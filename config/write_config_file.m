function write_config_file()
      ini = IniConfig();
      %Domain
      ini.AddSections('Domain');
      ini.AddKeys('Domain', 'domain', 'nanoDESI');      
      %Elasticsearch
      ini.AddSections('Elasticsearch');
      ini.AddKeys('Elasticsearch', 'ip-address', 'http://localhost:9200');
      location_to_save = uigetdir;
      ini.WriteFile([location_to_save filesep 'config.ini']);
      

