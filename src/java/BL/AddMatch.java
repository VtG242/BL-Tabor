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
public class AddMatch extends HttpServlet {

    DbPool dbPool = null;

    @Override
    public void init() throws ServletException {
        dbPool = new DbPool("java:comp/env/jdbc/PgBLTabor");
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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

        if (dbPool.isInitErr()) {

            msg = "<h2>Přidat zápas - DB pool exception:</h2>" + dbPool.getInitErrTxt();

        } else { //zpracujeme data o novem formulari

            Connection conn = null;
            PreparedStatement pstmt = null;

            //provedeme kontrolu povinnych udaju a ziskame data z formulare
            if (Integer.parseInt(request.getParameter("vt")) != Integer.parseInt(request.getParameter("ht")) || Integer.parseInt(request.getParameter("ht")) != 0 || Integer.parseInt(request.getParameter("vt")) != 0) {
            } else {
                msg = "Chybné zadání týmů !";
            }

            //jsou-li vyplnene vsechny povinne udaje provedeme zapis do databaze
            if (msg == null) {

                try {

                    conn = dbPool.getDBConn();

                    //zacneme db transakci
                    conn.setAutoCommit(false);
                    //nyni zapiseme nove hodnoty do matches
                    pstmt = conn.prepareStatement("INSERT INTO matches (msid,mrid,mhtid,mvtid,bp) VALUES (?,?,?,?,?)");
                    pstmt.setInt(1, (Integer) session.getAttribute("sid"));
                    pstmt.setInt(2, Integer.parseInt(request.getParameter("prid")));
                    pstmt.setInt(3, Integer.parseInt(request.getParameter("ht")));
                    pstmt.setInt(4, Integer.parseInt(request.getParameter("vt")));
                    pstmt.setString(5, request.getParameter("pbp")==null ? "N":"Y");
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
            response.sendRedirect(response.encodeRedirectURL("lround-matchadd.jsp?grid=" + request.getParameter("prid")+"&recsaved=true"));

        }

    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
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
     * Handles the HTTP <code>POST</code> method.
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
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
