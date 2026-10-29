
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Salon Results</title>
    <style>
        body {
            font-family: Arial;
        }

        table {
            width: 80%;
            margin: auto;
            border-collapse: collapse;
        }

        th, td {
            border: 1px solid black;
            padding: 8px;
            text-align: center;
        }

        h2, p {
            text-align: center;
        }
    </style>
</head>
<body>

<%
String customer = request.getParameter("customer");
String service = request.getParameter("service");
String date = request.getParameter("date");
String time = request.getParameter("time");

String message = "";

String url = "jdbc:mysql://localhost:3306/salon";
String user = "root";
String password = "universe";

try {
    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection con = DriverManager.getConnection(url, user, password);

    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String check = "SELECT * FROM salon_appt WHERE appt_date=? AND slot=?";
        PreparedStatement ps1 = con.prepareStatement(check);
        ps1.setDate(1, java.sql.Date.valueOf(date));
        ps1.setString(2, time);
        ResultSet rs1 = ps1.executeQuery();

        if (rs1.next()) {
            message = "Already booked";
        } else {
            String insert = "INSERT INTO salon_appt (customer, service, appt_date, slot) VALUES (?, ?, ?, ?)";
            PreparedStatement ps2 = con.prepareStatement(insert);
            ps2.setString(1, customer);
            ps2.setString(2, service);
            ps2.setDate(3, java.sql.Date.valueOf(date));
            ps2.setString(4, time);
            ps2.executeUpdate();
            ps2.close();
            message = "Saved successfully";
        }

        rs1.close();
        ps1.close();
    }
%>

<h2>Saved! All Records</h2>
<p><%= message %></p>

<table>
    <tr>
        <th>ID</th>
        <th>Customer</th>
        <th>Service</th>
        <th>Date</th>
        <th>Time Slot</th>
    </tr>

<%
    String sql = "SELECT * FROM salon_appt";
    PreparedStatement ps3 = con.prepareStatement(sql);
    ResultSet rs3 = ps3.executeQuery();

    while (rs3.next()) {
%>
    <tr>
        <td><%= rs3.getInt("id") %></td>
        <td><%= rs3.getString("customer") %></td>
        <td><%= rs3.getString("service") %></td>
        <td><%= rs3.getDate("appt_date") %></td>
        <td><%= rs3.getString("slot") %></td>
    </tr>
<%
    }

    rs3.close();
    ps3.close();
    con.close();

} catch (Exception e) {
    out.println("Database error: " + e.getMessage());
    application.log("Salon error", e);
}
%>

</table>

<p><a href="index.html">Book Another Appointment</a></p>

</body>
</html>
