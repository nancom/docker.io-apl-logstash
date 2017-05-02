input {
  beats {
     type => beats
     port => 5044
  }
  http {
    port => 8080
  }
  tcp {
    port => 514
    type => syslog
  }
  udp {
    port => 514
    type => syslog
  }
}

output {
  elasticsearch { hosts => ["elasticsearch:9200"] 
                  manage_template => false
                  index => "%{[@metadata][beat]}-%{+YYYY.MM.dd}"
                  document_type => "%{[@metadata][type]}"
                }
  stdout { codec => rubydebug }
}
