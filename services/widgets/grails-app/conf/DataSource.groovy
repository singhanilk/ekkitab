dataSource {
    pooled = true
	/**
    driverClassName = "org.hsqldb.jdbcDriver"
    username = "sa"
    password = ""
    **/
	driverClassName = "com.mysql.jdbc.Driver"
	username = "root"
	password = ""
}
hibernate {
    cache.use_second_level_cache = true
    cache.use_query_cache = true
    cache.provider_class = 'net.sf.ehcache.hibernate.EhCacheProvider'
}
// environment specific settings
environments {
    development {
        dataSource {
            dbCreate = "update" // one of 'create', 'create-drop','update'
            //url = "jdbc:hsqldb:file:affiliateDB;shutdown=true"
			url="jdbc:mysql://localhost:3306/AFFILIATE_DB"
        }
    }
    test {
        dataSource {
            dbCreate = "create"
            //url = "jdbc:hsqldb:file:affiliateDB;shutdown=true"
			url="jdbc:mysql://localhost:3306/AFFILIATE_DB_TEST;shutdown=true"
        }
    }
    production {
        dataSource {
            dbCreate = "update"
            url = "jdbc:hsqldb:file:affiliateDB;shutdown=true"
        }
    }
}
