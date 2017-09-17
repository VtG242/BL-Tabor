<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.io.*;"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel=StyleSheet href="css/default.css" type="text/css"/>
        <meta http-equiv="refresh" content="3">
        <title>BL - export do GD - průběh</title>
    </head>
    <body>
        <h1>GoodData - export</h1>
        
        <pre>
            <%
                File f = new File("/opt/GoodData/BL-Tabor/cl.output");

                if (f.exists() && !f.isDirectory()) {
                    
                    out.println("CL-Tool output:");
                    
                    String s = null, command = "cd /opt/GoodData/BL-Tabor;cat ./cl.output";
                    StringBuffer sb = new StringBuffer();
                    String[] cmd = {"/bin/bash", "-c", command};

                    Process p = Runtime.getRuntime().exec(cmd);

                    //je-li prikaz ukoncen - je vracena navratova hodnota (0=vse je v poradku)
                    int status = p.waitFor();
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
                    out.println("Chyba: Soubor s údaji o nahrávání nenalezen!.");
                }
            %>
        </pre>

    </body>
</html>
