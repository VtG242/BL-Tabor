/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package BL;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import VtGUtils.*;
import java.sql.*;
import java.util.regex.*;

/**
 *
 * @author VtG
 */
public class MatchScore extends HttpServlet {

    DbPool dbPool = null;

    @Override
    public void init() throws ServletException {
        dbPool = new DbPool("java:comp/env/jdbc/PgBLTabor");
    }

    /**
     * Processes requests for both HTTP
     * <code>GET</code> and
     * <code>POST</code> methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        //nastavime spravne kodovani
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(true);

        //promene pro cely request
        String msg = null;
        String[] PlayerHC = null;

        if (dbPool.isInitErr()) {

            msg = "<h2>Přidat score - DB pool exception:</h2>" + dbPool.getInitErrTxt();

        } else { //zpracujeme data o novem formulari

            Connection conn = null;
            PreparedStatement pstmt = null,pstmtgs = null;

            //provedeme kontrolu povinnych udaju a ziskame data z formulare
            if (BLMatch.isValidScore(request.getParameter("hpp1")) && BLMatch.isValidScore(request.getParameter("hpp2")) && BLMatch.isValidScore(request.getParameter("hpp3")) && BLMatch.isValidScore(request.getParameter("vpp1")) && BLMatch.isValidScore(request.getParameter("vpp2")) && BLMatch.isValidScore(request.getParameter("vpp3"))) {
                msg = "neco";
            } else {
                msg = "Neplatné score!";
            }

            //jsou-li vyplnene vsechny povinne udaje provedeme zapis do databaze
            if (msg == null) {

                try {

                    conn = dbPool.getDBConn();

                    //zacneme db transakci
                    conn.setAutoCommit(false);

                    //nejdrive smazeme vsechny informace o zapase z dt - table gsore, bp a endresults
                    pstmt = conn.prepareStatement("DELETE FROM gamescore WHERE gmid=?");
                    pstmt.setInt(1, Integer.parseInt(request.getParameter("pmid")));
                    pstmt.executeUpdate();
                    if (request.getParameter("pbp").equals("Y")) {
                        pstmt = conn.prepareStatement("DELETE FROM bp WHERE bpmid=?");
                        pstmt.setInt(1, Integer.parseInt(request.getParameter("pmid")));
                        pstmt.executeUpdate();
                        //zapiseme hrace do tabulky bp
                        pstmt = conn.prepareStatement("INSERT INTO bp (bpmid,bphplayer,bpvplayer) VALUES (?,?,?)");
                        pstmt.setInt(1, Integer.parseInt(request.getParameter("pmid")));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("hpbp")));
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("vpbp")));
                        pstmt.executeUpdate();
                    }
                    pstmt = conn.prepareStatement("DELETE FROM endresults WHERE emid=?");
                    pstmt.setInt(1, Integer.parseInt(request.getParameter("pmid")));
                    pstmt.executeUpdate();

                    //nyni zapiseme nove hodnoty do gamescore
                    pstmtgs = conn.prepareStatement("INSERT INTO gamescore (gmid,gtid,gpid,pmp,hc,points,gsid) VALUES (?,?,?,?,?,?,?)");
                    pstmtgs.setInt(1, Integer.parseInt(request.getParameter("pmid")));
                    pstmtgs.setInt(7, 1);

                    //domaci tym - hrac1
                    PlayerHC = Pattern.compile("_").split(request.getParameter("hp1"));
                    pstmtgs.setInt(2, Integer.parseInt(request.getParameter("pht")));
                    pstmtgs.setInt(3, Integer.parseInt(PlayerHC[0]));
                    pstmtgs.setInt(4, 1);
                    pstmtgs.setInt(5, Integer.parseInt(PlayerHC[1]));
                    pstmtgs.setInt(6, Integer.parseInt(request.getParameter("hpp1")));
                    pstmtgs.setInt(7, 1);
                    pstmtgs.executeUpdate();

                    //domaci tym - hrac2
                    PlayerHC = Pattern.compile("_").split(request.getParameter("hp2"));
                    pstmtgs.setInt(2, Integer.parseInt(request.getParameter("pht")));
                    pstmtgs.setInt(3, Integer.parseInt(PlayerHC[0]));
                    pstmtgs.setInt(4, 2);
                    pstmtgs.setInt(5, Integer.parseInt(PlayerHC[1]));
                    pstmtgs.setInt(6, Integer.parseInt(request.getParameter("hpp2")));
                    pstmtgs.setInt(7, 1);
                    pstmtgs.executeUpdate();

                    //domaci tym - hrac3
                    PlayerHC = Pattern.compile("_").split(request.getParameter("hp3"));
                    pstmtgs.setInt(2, Integer.parseInt(request.getParameter("pht")));
                    pstmtgs.setInt(3, Integer.parseInt(PlayerHC[0]));
                    pstmtgs.setInt(4, 3);
                    pstmtgs.setInt(5, Integer.parseInt(PlayerHC[1]));
                    pstmtgs.setInt(6, Integer.parseInt(request.getParameter("hpp3")));
                    pstmtgs.setInt(7, 1);
                    pstmtgs.executeUpdate();

                    //hostujici tym - hrac1
                    PlayerHC = Pattern.compile("_").split(request.getParameter("vp1"));
                    pstmtgs.setInt(2, Integer.parseInt(request.getParameter("pvt")));
                    pstmtgs.setInt(3, Integer.parseInt(PlayerHC[0]));
                    pstmtgs.setInt(4, 1);
                    pstmtgs.setInt(5, Integer.parseInt(PlayerHC[1]));
                    pstmtgs.setInt(6, Integer.parseInt(request.getParameter("vpp1")));
                    pstmtgs.setInt(7, 1);
                    pstmtgs.executeUpdate();

                    //hostujici tym - hrac2
                    PlayerHC = Pattern.compile("_").split(request.getParameter("vp2"));
                    pstmtgs.setInt(2, Integer.parseInt(request.getParameter("pvt")));
                    pstmtgs.setInt(3, Integer.parseInt(PlayerHC[0]));
                    pstmtgs.setInt(4, 2);
                    pstmtgs.setInt(5, Integer.parseInt(PlayerHC[1]));
                    pstmtgs.setInt(6, Integer.parseInt(request.getParameter("vpp2")));
                    pstmtgs.setInt(7, 1);
                    pstmtgs.executeUpdate();

                    //hostujici tym - hrac3
                    PlayerHC = Pattern.compile("_").split(request.getParameter("vp3"));
                    pstmtgs.setInt(2, Integer.parseInt(request.getParameter("pvt")));
                    pstmtgs.setInt(3, Integer.parseInt(PlayerHC[0]));
                    pstmtgs.setInt(4, 3);
                    pstmtgs.setInt(5, Integer.parseInt(PlayerHC[1]));
                    pstmtgs.setInt(6, Integer.parseInt(request.getParameter("vpp3")));
                    pstmtgs.setInt(7, 1);
                    pstmtgs.executeUpdate();

                    //nyni provedeme zapis hracu kteri hraji cerneho petra do tabulky BP

                    //vlozime zaznam do end results
                    BLMatch match = new BLMatch(conn, Integer.parseInt(request.getParameter("pmid")));
                    pstmt = conn.prepareStatement("INSERT INTO endresults (esid,erid,emid,etid,scoretotal,points1,points2,points3,pointstotal) VALUES (?,?,?,?,?,?,?,?,?)");
                    pstmt.setInt(1, (Integer) session.getAttribute("sid"));
                    pstmt.setInt(2, match.getRoundID());
                    pstmt.setInt(3, Integer.parseInt(request.getParameter("pmid")));
                    //zapis pro domaci tym
                    pstmt.setInt(4, Integer.parseInt(request.getParameter("pht")));
                    pstmt.setInt(5, match.getHTPoints());
                    pstmt.setDouble(6, match.getHTP1Points());
                    pstmt.setDouble(7, match.getHTP2Points());
                    pstmt.setDouble(8, match.getHTP3Points());
                    pstmt.setDouble(9, match.getMatchResult(0));
                    pstmt.executeUpdate();
                    //zapis hostujici tym
                    pstmt.setInt(4, Integer.parseInt(request.getParameter("pvt")));
                    pstmt.setInt(5, match.getVTPoints());
                    pstmt.setDouble(6, match.getVTP1Points());
                    pstmt.setDouble(7, match.getVTP2Points());
                    pstmt.setDouble(8, match.getVTP3Points());
                    pstmt.setDouble(9, match.getMatchResult(1));
                    pstmt.executeUpdate();

                    pstmt.close();

                    //ukoncime transakci
                    conn.commit();

                    conn.close();


                } catch (SQLException e) {

                    msg = "Chyba SQL:" + e.getMessage();

                } finally {

                    if (pstmt != null) {
                        try {
                            pstmt.close();
                        } catch (SQLException sqlex) {
                            // ignore -- as we can't do anything about it here
                        }
                        pstmt = null;
                    }
                    if (conn != null) {
                        try {
                            conn.close();
                        } catch (SQLException sqlex) {
                            // ignore -- as we can't do anything about it here
                        }
                        conn = null;
                    }

                }

            }

            //presmerovani na stranku kde probehne info o probehlem pozadavku
            session.setAttribute("s_msg", msg);
            //response.sendRedirect(response.encodeRedirectURL("lround-mresult.jsp?gmid=" + request.getParameter("pmid")));

        }

    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP
     * <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP
     * <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
