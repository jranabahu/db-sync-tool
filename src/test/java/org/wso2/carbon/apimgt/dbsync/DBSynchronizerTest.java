package org.wso2.carbon.apimgt.dbsync;

import org.apache.log4j.PropertyConfigurator;
import org.junit.Ignore;
import org.junit.Test;

import java.util.Locale;

public class DBSynchronizerTest {

    @Ignore
    @Test
    public void testMainLocal() {
        PropertyConfigurator.configure(getClass().getClassLoader().getResourceAsStream("log4j.properties"));

        Locale.setDefault(Locale.ENGLISH);
        DBSynchronizer dbSynchronizer = new DBSynchronizer();
        String[] pars = { "jdbc:oracle:thin:amdb_200@10.10.10.2:1521/xe", "amdb_200", "amdb_200",
                "oracle.jdbc.OracleDriver",

                "jdbc:oracle:thin:amdb_260@10.10.10.2:1521/xe", "amdb_260", "amdb_260", "oracle.jdbc.OracleDriver", };
        dbSynchronizer.main(pars);
    }

    @Ignore
    @Test
    public void testMainRemote() {
        PropertyConfigurator.configure(getClass().getClassLoader().getResourceAsStream("log4j.properties"));

        Locale.setDefault(Locale.ENGLISH);
        DBSynchronizer dbSynchronizer = new DBSynchronizer();
        String[] pars = { "jdbc:oracle:thin:amdb_200@192.168.104.32:1521/orcl", "amdb_200", "amdb_200",
                "oracle.jdbc.OracleDriver",

                "jdbc:oracle:thin:amdb_260@192.168.104.32:1521/orcl", "amdb_260", "amdb_260", "oracle.jdbc.OracleDriver", };
        dbSynchronizer.main(pars);
    }
}
