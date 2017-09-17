package BL;

import java.sql.*;
import javax.servlet.http.*;

/**
 *
 * @author VtG
 */
public class BLMatch {

    /** ID ligového zápasu */
    private int matchID = 0;
    /** ID ligového kola*/
    private int matchRoundID = 0;
    /** Nazev domácího týmu*/
    private String matchHomeTeamName = "";
    /** Nazev hostujícího týmu*/
    private String matchVisitorTeamName = "";
    /** Jméno 1. hráče domácího týmu*/
    private String matchHTP1Name = "";
    /** Jméno 2. hráče domácího týmu*/
    private String matchHTP2Name = "";
    /** Jméno 2. hráče domácího týmu*/
    private String matchHTP3Name = "";
    /** Počet bodů 1. hráče domácího týmu*/
    private int matchHTP1Points = 0;
    /** Počet bodů 2. hráče domácího týmu*/
    private int matchHTP2Points = 0;
    /** Počet bodů 3. hráče domácího týmu*/
    private int matchHTP3Points = 0;
    /** Počet bodů v zapase 1. hráče domácího týmu*/
    private double matchHTP1GamePoints = 0;
    /** Počet bodů v zapase 2. hráče domácího týmu*/
    private double matchHTP2GamePoints = 0;
    /** Počet bodů v zapase 3. hráče domácího týmu*/
    private double matchHTP3GamePoints = 0;
    /** Jméno 1. hráče hostujícího týmu*/
    private String matchVTP1Name = "";
    /** Jméno 2. hráče hostujícího týmu*/
    private String matchVTP2Name = "";
    /** Jméno 3. hráče hostujícího týmu*/
    private String matchVTP3Name = "";
    /** Počet bodů 1. hráče hostujícího týmu*/
    private int matchVTP1Points = 0;
    /** Počet bodů 2. hráče hostujícího týmu*/
    private int matchVTP2Points = 0;
    /** Počet bodů 3. hráče hostujícího týmu*/
    private int matchVTP3Points = 0;
    /** Počet bodů v zapase 1. hráče hostujícího týmu*/
    private double matchVTP1GamePoints = 0;
    /** Počet bodů v zapase 2. hráče hostujícího týmu*/
    private double matchVTP2GamePoints = 0;
    /** Počet bodů v zapase 3. hráče hostujícího týmu*/
    private double matchVTP3GamePoints = 0;
    /** Počet bodů za celkovy vysledek domaci tým*/
    private double matchHTGamePoints = 0;
    /** Počet bodů za celkovy vysledek hostujici tým*/
    private double matchVTGamePoints = 0;
    /** Černý Petr*/
    private boolean matchBP = false;
    /** Černý Petr - pozice domacího hráče*/
    private int matchBPHPpos = 0;
    /** Černý Petr - pozice hostujicího hráče*/
    private int matchBPVPpos = 0;
    /** Černý Petr - jmeno domacího hráče*/
    private String matchBPHPname = "";
    /** Černý Petr - jmeno hostujiciho hráče*/
    private String matchBPVPname = "";
    /** Černý Petr - body domaciho hráče*/
    private int matchHTBPGamePoints = 0;
    /** Černý Petr - body hostujiciho hráče*/
    private int matchVTBPGamePoints = 0;
    /** Pole vyslednych bodu 0-HT 1-VT */
    private double[] matchResult = {0.0, 0.0};
    /** Pole vyslednych bodu domacích hráčů 0-ppos1 1-ppos2 2-ppos3 */
    public int[] matchHPlayerResult = {0, 0, 0, 0};
    /** Pole vyslednych bodu hostujících hráčů 0-ppos1 1-ppos2 2-ppos3 */
    public int[] matchVPlayerResult = {0, 0, 0, 0};
    /** Celkovy pocet bodu (p1+p2+p3) domaciho tymu*/
    private int matchHTpoints = 0;
    /** Celkovy pocet bodu (p1+p2+p3) histujiciho tymu*/
    private int matchVTpoints = 0;

    /**Zpusob vytvoreni objektu dotazem do db pro zadane ID
     * @param conn Databazové spojení
     * @param matchID ID ligového zápasu
     */
    public BLMatch(Connection conn, int matchID) throws SQLException {

        String SQLQueryMatchInfo = "";
        PreparedStatement pstmtMatchInfo = null;
        ResultSet resultSetMatchInfo = null;

        this.matchID = matchID;

        SQLQueryMatchInfo = "SELECT "
                + "matches.mrid,"
                + "matches.mid,"
                + "getteamname(matches.mhtid) as ht,"
                + "gethpname(matches.mid,1) as hpn1,"
                + "gethppoints(matches.mid,1) as hpp1,"
                + "gethpname(matches.mid,2) as hpn2,"
                + "gethppoints(matches.mid,2) as hpp2,"
                + "gethpname(matches.mid,3) as hpn3,"
                + "gethppoints(matches.mid,3) as hpp3,"
                + "getteamname(mvtid) as vt,"
                + "getvpname(matches.mid,1) as vpn1,"
                + "getvppoints(matches.mid,1) as vpp1,"
                + "getvpname(matches.mid,2) as vpn2,"
                + "getvppoints(matches.mid,2) as vpp2,"
                + "getvpname(matches.mid,3) as vpn3,"
                + "getvppoints(matches.mid,3) as vpp3,"
                + "matches.bp "
                + "FROM matches "
                + "WHERE matches.mid=?";

        pstmtMatchInfo = conn.prepareStatement(SQLQueryMatchInfo);
        pstmtMatchInfo.setInt(1, matchID);

        resultSetMatchInfo = pstmtMatchInfo.executeQuery();
        while (resultSetMatchInfo.next()) {
            this.matchRoundID = resultSetMatchInfo.getInt("mrid");
            this.matchHomeTeamName = resultSetMatchInfo.getString("ht");
            this.matchHTP1Name = resultSetMatchInfo.getString("hpn1")==null ? "":resultSetMatchInfo.getString("hpn1");
            this.matchHTP1Points = resultSetMatchInfo.getInt("hpp1");
            this.matchHTP2Name = resultSetMatchInfo.getString("hpn2")==null ? "":resultSetMatchInfo.getString("hpn2");
            this.matchHTP2Points = resultSetMatchInfo.getInt("hpp2");
            this.matchHTP3Name = resultSetMatchInfo.getString("hpn3")==null ? "":resultSetMatchInfo.getString("hpn3");
            this.matchHTP3Points = resultSetMatchInfo.getInt("hpp3");
            this.matchVisitorTeamName = resultSetMatchInfo.getString("vt");
            this.matchVTP1Name = resultSetMatchInfo.getString("vpn1")==null ? "":resultSetMatchInfo.getString("vpn1");
            this.matchVTP1Points = resultSetMatchInfo.getInt("vpp1");
            this.matchVTP2Name = resultSetMatchInfo.getString("vpn2")==null ? "":resultSetMatchInfo.getString("vpn2");
            this.matchVTP2Points = resultSetMatchInfo.getInt("vpp2");
            this.matchVTP3Name = resultSetMatchInfo.getString("vpn3")==null ? "":resultSetMatchInfo.getString("vpn3");
            this.matchVTP3Points = resultSetMatchInfo.getInt("vpp3");
            this.matchBP = resultSetMatchInfo.getString("BP").equals("Y") ? true : false;
        }
        //udaje o Cernem Petru
        if (matchBP) {
            SQLQueryMatchInfo = "SELECT bpmid,bphplayer,bpvplayer,"
                    + "getplayerposition(bpmid,bphplayer) as hpp,"
                    + "gethpname(bphplayer) as hpn,"
                    + "getplayerposition(bpmid,bpvplayer) as vpp,"
                    + "gethpname(bpvplayer) as vpn "
                    + "FROM bp "
                    + "WHERE bpmid=?";
            pstmtMatchInfo = conn.prepareStatement(SQLQueryMatchInfo);
            pstmtMatchInfo.setInt(1, this.matchID);

            resultSetMatchInfo = pstmtMatchInfo.executeQuery();
            while (resultSetMatchInfo.next()) {
                this.matchBPHPpos = resultSetMatchInfo.getInt("hpp");
                this.matchBPVPpos = resultSetMatchInfo.getInt("vpp");
                this.matchBPHPname = resultSetMatchInfo.getString("hpn");
                this.matchBPVPname = resultSetMatchInfo.getString("vpn");
            }

        }

        //celkove skore
        this.matchHTpoints = this.matchHTP1Points + this.matchHTP2Points + this.matchHTP3Points;
        this.matchVTpoints = this.matchVTP1Points + this.matchVTP2Points + this.matchVTP3Points;

        //pole obsahuji vysledky her pro domaci hrace 1-3 - pro vypocet CP
        this.matchHPlayerResult[1] = this.matchHTP1Points;
        this.matchHPlayerResult[2] = this.matchHTP2Points;
        this.matchHPlayerResult[3] = this.matchHTP3Points;
        //pole obsahuji vysledky her pro hostujici hrace 1-3 - pro vypocet CP
        this.matchVPlayerResult[1] = this.matchVTP1Points;
        this.matchVPlayerResult[2] = this.matchVTP2Points;
        this.matchVPlayerResult[3] = this.matchVTP3Points;

        //slo by predelat do funkce  a vyuzit pole viz vyse
        //vysledky za celkove skore - 2 body za vyhru, 1 bod za remizu
        if (this.matchHTpoints == this.matchVTpoints) {
            this.matchResult[0] += 1;
            this.matchResult[1] += 1;
            this.matchHTGamePoints = 1;
            this.matchVTGamePoints = 1;
        } else if (this.matchHTpoints > this.matchVTpoints) {
            this.matchResult[0] += 2;
            this.matchHTGamePoints = 2;
        } else {
            this.matchResult[1] += 2;
            this.matchVTGamePoints = 2;
        }

        //vypocty pro celkove body za hrace a team
        if (this.matchHTP1Points == this.matchVTP1Points) {
            this.matchResult[0] += 0.5;
            this.matchResult[1] += 0.5;
            this.matchHTP1GamePoints = 0.5;
            this.matchVTP1GamePoints = 0.5;
        } else if (this.matchHTP1Points > this.matchVTP1Points) {
            this.matchResult[0] += 1;
            this.matchHTP1GamePoints = 1;
        } else {
            this.matchResult[1] += 1;
            this.matchVTP1GamePoints = 1;
        }
        if (this.matchHTP2Points == this.matchVTP2Points) {
            this.matchResult[0] += 0.5;
            this.matchResult[1] += 0.5;
            this.matchHTP2GamePoints = 0.5;
            this.matchVTP2GamePoints = 0.5;
        } else if (this.matchHTP2Points > this.matchVTP2Points) {
            this.matchResult[0] += 1;
            this.matchHTP2GamePoints = 1;
        } else {
            this.matchResult[1] += 1;
            this.matchVTP2GamePoints = 1;
        }
        if (this.matchHTP3Points == this.matchVTP3Points) {
            this.matchResult[0] += 0.5;
            this.matchResult[1] += 0.5;
            this.matchHTP3GamePoints = 0.5;
            this.matchVTP3GamePoints = 0.5;
        } else if (this.matchHTP3Points > this.matchVTP3Points) {
            this.matchResult[0] += 1;
            this.matchHTP3GamePoints = 1;
        } else {
            this.matchResult[1] += 1;
            this.matchVTP3GamePoints = 1;
        }

        if (this.matchBP) {
            if (this.matchHPlayerResult[this.matchBPHPpos] == this.matchVPlayerResult[this.matchBPVPpos]) {
                this.matchResult[0] += 0;
                this.matchResult[1] += 0;
                this.matchHTBPGamePoints = 0;
                this.matchVTBPGamePoints = 0;
            } else if (this.matchHPlayerResult[this.matchBPHPpos] > this.matchVPlayerResult[this.matchBPVPpos]) {
                this.matchResult[0] += 2;
                this.matchHTBPGamePoints = 2;
            } else {
                this.matchResult[1] += 2;
                this.matchVTBPGamePoints = 2;
            }
        }
    }

    /**Zpusob vytvoreni objektu dotazem do db pro zadane ID
     * @param conn Databazové spojení
     * @param request Formularova data s vysledky zapasu
     */
    public BLMatch(Connection conn, HttpServletRequest request) throws SQLException {
    }
    /*
     * GET METODY PRO PRIVATE PROMENE
     */

    public String getHomeTeamName() {
        return this.matchHomeTeamName;
    }

    public String getVisitorTeamName() {
        return this.matchVisitorTeamName;
    }

    public String getHTP1Name() {
        return this.matchHTP1Name;
    }

    public String getHTP2Name() {
        return this.matchHTP2Name;
    }

    public String getHTP3Name() {
        return this.matchHTP3Name;
    }

    public String getVTP1Name() {
        return this.matchVTP1Name;
    }

    public String getVTP2Name() {
        return this.matchVTP2Name;
    }

    public String getVTP3Name() {
        return this.matchVTP3Name;
    }

    public int getHTP1Points() {
        return this.matchHTP1Points;
    }

    public int getHTP2Points() {
        return this.matchHTP2Points;
    }

    public int getHTP3Points() {
        return this.matchHTP3Points;
    }

    public double getHTP1GamePoints() {
        return this.matchHTP1GamePoints;
    }

    public double getHTP2GamePoints() {
        return this.matchHTP2GamePoints;
    }

    public double getHTP3GamePoints() {
        return this.matchHTP3GamePoints;
    }

    public int getVTP1Points() {
        return this.matchVTP1Points;
    }

    public int getVTP2Points() {
        return this.matchVTP2Points;
    }

    public int getVTP3Points() {
        return this.matchVTP3Points;
    }

    public double getVTP1GamePoints() {
        return this.matchVTP1GamePoints;
    }

    public double getVTP2GamePoints() {
        return this.matchVTP2GamePoints;
    }

    public double getVTP3GamePoints() {
        return this.matchVTP3GamePoints;
    }

    /**Funkce vraci true pokud je v zapase nasazen Cerny Petr
     */
    public boolean getBP() {
        return this.matchBP;
    }

    /**Funkce vraci pozici domaciho hrace pro Cerneho Petra
     */
    public int getBPHPpos() {
        return this.matchBPHPpos;
    }

    /**Funkce vraci pozici hostujiciho hrace pro Cerneho Petra
     */
    public int getBPVPpos() {
        return this.matchBPVPpos;
    }

    /**Funkce vraci jmeno domaciho hrace pro Cerneho Petra
     */
    public String getBPHPname() {
        return this.matchBPHPname;
    }

    /**Funkce vraci jmeno hostujiciho hrace pro Cerneho Petra
     */
    public String getBPVPname() {
        return this.matchBPVPname;
    }

    /**Funkce vraci pocet ziskanych bodu domaciho hrace pro Cerneho Petra
     */
    public int getBPHTGamePoints() {
        return this.matchHTBPGamePoints;
    }

    /**Funkce vraci pocet ziskanych bodu hostujiciho hrace pro Cerneho Petra
     */
    public int getBPVTGamePoints() {
        return this.matchVTBPGamePoints;
    }

    /**Funkce vraci soucet bodu z odehranych her + HC hracu domaciho tymu
     */
    public int getHTPoints() {
        return this.matchHTpoints;
    }

    /**Funkce vraci soucet bodu z odehranych her+HC hracu hostujiciho tymu
     */
    public int getVTPoints() {
        return this.matchVTpoints;
    }

    /**Funkce vraci celkove bodove vysledky zapasu
     * @param index 0-HT 1-VT
     */
    public double getMatchResult(int index) {
        return this.matchResult[index];
    }

    /**Funkce vraci body za zapas pro celkovy soucet - domaci tym
     */
    public double getHTGamePoints() {
        return this.matchHTGamePoints;
    }

    /**Funkce vraci body za zapas pro celkovy soucet - hostujici tym
     */
    public double getVTGamePoints() {
        return this.matchVTGamePoints;
    }

    /**Funkce vraci ID ligoveho kola
     */
    public int getRoundID() {
        return this.matchRoundID;
    }

    //Staticke promene
    protected static boolean isValidScore(String testVariable) {
        int p = 0;
        try {
            p = Integer.parseInt(testVariable);
            return (p > 0 && p <= 300) ? true : false;

        } catch (NumberFormatException e) {
            return false;
        }
    }
}
