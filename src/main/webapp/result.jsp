
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

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
    "jdbc:mysql://localhost:3306/salon", "root", "password"
);

if (request.getMethod().equalsIgnoreCase("POST")) {

    PreparedStatement check = con.prepareStatement(
        "SELECT * FROM salon_appt WHERE appt_date=? AND slot=?"
    );

    check.setDate(1, java.sql.Date.valueOf(date));
    check.setString(2, time);

    ResultSet rs = check.executeQuery();

    if (rs.next()) {
        message = "Already booked";
    } else {
        PreparedStatement ps = con.prepareStatement(
            "INSERT INTO salon_appt (customer, service, appt_date, slot) VALUES (?, ?, ?, ?)"
        );

        ps.setString(1, customer);
        ps.setString(2, service);
        ps.setDate(3, java.sql.Date.valueOf(date));
        ps.setString(4, time);

        ps.executeUpdate();
        ps.close();

        message = "Saved successfully";
    }

    rs.close();
    check.close();
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
        <th>Time slot</th>
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
%>

</table>

<p><a href="index.html">Book Another Appointment</a></p>

</body>
</html>
