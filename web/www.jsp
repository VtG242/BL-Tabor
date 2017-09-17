<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.io.*;"%>

<%@page errorPage="error.jsp"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel=StyleSheet href="css/default.css" type="text/css"/>        
        <title>BL - export do GD</title>
    </head>
    <body>
        <h1>WWW - export</h1>
        <pre>
            <%
                String s = null, command = "cd /opt/GoodData/BL-Hluboka;./BL-sso.sh";
                StringBuffer sb = new StringBuffer();
                String[] cmd = {"/bin/bash", "-c", command};

                out.println("");

                Process p = Runtime.getRuntime().exec(cmd);

                //je-li prikaz ukoncen - je vracena navratova hodnota (0=vse je v poradku)
                int status = p.waitFor();

                if (status == 0) {
                    //spusteni prikazu probehlo uspesne
                    out.println("Vytvoření index.html proběhlo úspěšně.");

                    command = "cd /opt/GoodData/BL-Hluboka;./ftp.sh";
                    cmd[2] = command;

                    out.println("Přenos index.html na FTP:");

                    p = Runtime.getRuntime().exec(cmd);
                    status = p.waitFor();
                    if (status == 0) {
                        //spusteni prikazu probehlo uspesne - cteme ze standartniho vystupu programu
                        BufferedReader stdInput = new BufferedReader(new InputStreamReader(p.getInputStream()));
                        // vytiskneme vystup spousteneho souboru
                        while ((s = stdInput.readLine()) != null) {
                            sb.append(s).append("\n");
                        }
                        out.println(sb.toString());
                        stdInput.close();
                    } else {
                        //spusteni prikazu neprobehlo uspesne - cteme z chyboveho vystupu programu
                        BufferedReader stdErr = new BufferedReader(new InputStreamReader(p.getErrorStream()));
                        // read the output from the command
                        while ((s = stdErr.readLine()) != null) {
                            sb.append(s).append("\n");
                        }
                        out.println(sb.toString());
                        stdErr.close();
                    }
                } else {
                    //spusteni prikazu neprobehlo uspesne - cteme z chyboveho vystupu programu
                    BufferedReader stdErr = new BufferedReader(new InputStreamReader(p.getErrorStream()));
                    // read the output from the command
                    while ((s = stdErr.readLine()) != null) {
                        sb.append(s).append("\n");
                    }
                    out.println(sb.toString());
                    stdErr.close();
                }
            %>
        </pre>
        <%
            BufferedReader br = null;

            try {

                String sCurrentLine;

                br = new BufferedReader(new FileReader("/opt/GoodData/BL-Hluboka/sso.url"));

                while ((sCurrentLine = br.readLine()) != null) {
                    out.println("<a href='" + sCurrentLine + "' target='_blank'>[ Test www ]</a>");
                }

            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                try {
                    if (br != null) {
                        br.close();
                    }
                } catch (IOException ex) {
                    ex.printStackTrace();
                }
            }
        %>
    </body>
</html>
