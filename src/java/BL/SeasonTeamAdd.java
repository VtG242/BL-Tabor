/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package BL;

import javax.servlet.*;
import javax.servlet.http.*;

import java.io.*;
import java.sql.*;
import VtGUtils.*;

/**
 *
 * @author VtG
 */
public class SeasonTeamAdd extends HttpServlet {

    DbPool dbPool = null;

    @Override
    public void init() throws ServletException {
        dbPool = new DbPool("java:comp/env/jdbc/PgBLTabor");
    }

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

        HttpSession session = request.getSession(true);

        //promene pro cely request
        String msg = null;
        String backPage = "season-team-add.jsp";

        //nastavime spravne kodovani
        request.setCharacterEncoding("UTF-8");

        if (dbPool.isInitErr()) {

            msg = "<h2>Smazání hráče ze soupisky - DB pool exception:</h2>" + dbPool.getInitErrTxt();

        } else { //zpracujeme data o novem formulari

            Connection conn = null;
            PreparedStatement pstmt = null;

            //jsou-li vyplnene vsechny povinne udaje provedeme zapis do databaze
            if (request.getParameter("gpid") == null) {
                msg = "Neplatné ID hráče!";
            }
            if (msg == null) {

                try {

                    conn = dbPool.getDBConn();

                    //zacneme db transakci
                    conn.setAutoCommit(false);

                    pstmt = conn.prepareStatement("DELETE from lineups WHERE lsid=? AND llid=? AND ltid=? AND lpid=?");
                    pstmt.setInt(1, (Integer) session.getAttribute("sid"));
                    pstmt.setInt(2, (Integer) session.getAttribute("lid"));                    
                    pstmt.setInt(3, Integer.parseInt(request.getParameter("gtid")));
                    pstmt.setInt(4, Integer.parseInt(request.getParameter("gpid")));
                    pstmt.executeUpdate();
                    pstmt.close();
                    //ukoncime transakci
                    conn.commit();
                    conn.close();
                    
                    backPage += "?gtid=" + request.getParameter("gtid") + "&gtname=" + request.getParameter("gtname") ;
                    
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
            response.sendRedirect(response.encodeRedirectURL(backPage));
        }

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

        HttpSession session = request.getSession(true);

        //promene pro cely request
        String msg = null;
        String backPage = "season-teams.jsp";

        //nastavime spravne kodovani
        request.setCharacterEncoding("UTF-8");

        if (dbPool.isInitErr()) {

            msg = "<h2>Přidání/úprava týmu (sezóna) - DB pool exception:</h2>" + dbPool.getInitErrTxt();

        } else { //zpracujeme data o novem formulari

            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            String[] pit = null;
            int hcz, hcv = 0;
            double avg = 0.00;
            int hc = 0;

            //jsou-li vyplnene vsechny povinne udaje provedeme zapis do databaze
            if (request.getParameterValues("pit") == null) {
                msg = "Seznam hráču k zapsání do týmu je prázdný!";
            } else {
                pit = request.getParameterValues("pit");
                if (pit[0].equals("")){
                   msg = "Seznam hráču k zapsání do týmu je prázdný!"; 
                }
            }

            if (msg == null) {

                try {

                    conn = dbPool.getDBConn();

                    //zacneme db transakci
                    conn.setAutoCommit(false);

                    for (int loopIndex = 0; loopIndex < pit.length; loopIndex++) {

                        pstmt = conn.prepareStatement("INSERT INTO lineups (lsid,ltid,lpid,llid) VALUES (?,?,?,?)");
                        pstmt.setInt(1, (Integer) session.getAttribute("sid"));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("ptid")));
                        pstmt.setInt(3, Integer.parseInt(pit[loopIndex]));
                        pstmt.setInt(4, (Integer) session.getAttribute("lid"));
                        pstmt.executeUpdate();

                    }
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
            response.sendRedirect(response.encodeRedirectURL(backPage));
        }

    }

    @Override
    public String getServletInfo() {
        return "Servlet pro správu supisek týmů v sezóně.";
    }
}
