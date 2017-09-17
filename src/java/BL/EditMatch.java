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
public class EditMatch extends HttpServlet {

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
            PreparedStatement pstmt = null;
            boolean delete = false;

            //provedeme kontrolu povinnych udaju a ziskame data z formulare
            if (Integer.parseInt(request.getParameter("vt")) != Integer.parseInt(request.getParameter("ht")) || Integer.parseInt(request.getParameter("ht")) != 0 || Integer.parseInt(request.getParameter("vt")) != 0) {
                delete = request.getParameter("pdm") == null ? false : true;
            } else {
                msg = "Chybné zadání týmů !";
            }

            //jsou-li vyplnene vsechny povinne udaje provedeme zapis do databaze
            if (msg == null) {

                try {

                    conn = dbPool.getDBConn();

                    //zacneme db transakci
                    conn.setAutoCommit(false);

                    //smazeme zapsane vysledky k zapasu
                    pstmt = conn.prepareStatement("DELETE FROM gamescore WHERE gmid=?");
                    pstmt.setInt(1, Integer.parseInt(request.getParameter("pmid")));
                    pstmt.executeUpdate();
                    pstmt = conn.prepareStatement("DELETE FROM endresults WHERE emid=?");
                    pstmt.setInt(1, Integer.parseInt(request.getParameter("pmid")));
                    pstmt.executeUpdate();
                    pstmt = conn.prepareStatement("DELETE FROM bp WHERE bpmid=?");
                    pstmt.setInt(1, Integer.parseInt(request.getParameter("pmid")));
                    pstmt.executeUpdate();

                    //pri pozadavku na smazani celeho zapisu smazeme zapas mamisto update
                    if (delete) {
                        pstmt = conn.prepareStatement("DELETE FROM matches WHERE mid=?");
                        pstmt.setInt(1, Integer.parseInt(request.getParameter("pmid")));
                        pstmt.executeUpdate();
                    } else {
                        //nyni zapiseme nove hodnoty do matches
                        pstmt = conn.prepareStatement("UPDATE matches SET mhtid=?,mvtid=?,bp=? WHERE mid=?");
                        pstmt.setInt(1, Integer.parseInt(request.getParameter("ht")));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("vt")));
                        pstmt.setString(3, request.getParameter("pbp") == null ? "N" : "Y");
                        pstmt.setInt(4, Integer.parseInt(request.getParameter("pmid")));
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
            if (delete) {
                response.sendRedirect(response.encodeRedirectURL("lrounds.jsp"));
            } else {
                response.sendRedirect(response.encodeRedirectURL("lround-matchedit.jsp?gmit=" + request.getParameter("pmid") + "&ght=" + request.getParameter("ht") + "&gvt=" + request.getParameter("vt") + "&gbp=" + (request.getParameter("pbp") == null ? "N" : "Y") + "&gdm=N"));
            }

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
