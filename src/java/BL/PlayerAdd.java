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

/**
 *
 * @author VtG
 */
public class PlayerAdd extends HttpServlet {

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
        
        //nastavime spravne kodovani
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(true);

        //promene pro cely request
        String msg = null;

        if (dbPool.isInitErr()) {

            msg = "<h2>Smazat hráče - DB pool exception:</h2>" + dbPool.getInitErrTxt();

        } else { //zpracujeme data o novem formulari

            Connection conn = null;
            PreparedStatement pstmt = null;

            //provedeme kontrolu povinnych udaju a ziskame data z formulare
            if (request.getParameter("gpid")!= null) {
            } else {
                msg = "ID hráče musí být zadáno !";
            }

            //jsou-li vyplnene vsechny povinne udaje provedeme zapis do databaze
            if (msg == null) {

                try {

                    conn = dbPool.getDBConn();

                    //zacneme db transakci
                    conn.setAutoCommit(false);
                    //nyni zapiseme nove hodnoty do matches
                    pstmt = conn.prepareStatement("DELETE FROM players WHERE pid=?");
                    pstmt.setInt(1,Integer.parseInt(request.getParameter("gpid")));
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
            response.sendRedirect(response.encodeRedirectURL("player-list.jsp"));

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

        //nastavime spravne kodovani
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(true);

        //promene pro cely request
        String msg = null;

        if (dbPool.isInitErr()) {

            msg = "<h2>Přidat hráče - DB pool exception:</h2>" + dbPool.getInitErrTxt();

        } else { //zpracujeme data o novem formulari

            Connection conn = null;
            PreparedStatement pstmt = null;

            //provedeme kontrolu povinnych udaju a ziskame data z formulare
            if (request.getParameter("ppname") != null && request.getParameter("ppsurname") != null && request.getParameter("ppsex") != null) {
            } else {
                msg = "Všechna pole musí být zadána !";
            }

            //jsou-li vyplnene vsechny povinne udaje provedeme zapis do databaze
            if (msg == null) {

                try {

                    conn = dbPool.getDBConn();

                    //zacneme db transakci
                    conn.setAutoCommit(false);
                    //nyni zapiseme nove hodnoty do matches
                    pstmt = conn.prepareStatement("INSERT INTO players (pname,psurname,pgender) VALUES (?,?,?)");
                    pstmt.setString(1, request.getParameter("ppname"));
                    pstmt.setString(2, request.getParameter("ppsurname"));
                    pstmt.setString(3, request.getParameter("ppsex"));

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
            response.sendRedirect(response.encodeRedirectURL("player-add.jsp?recsaved=true"));
        }

    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Přidání/mazání hráče";
    }
}
