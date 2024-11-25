<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<html>
<body>
<%@ page import="java.sql.*" %>

<%
String url = "jdbc:mysql://localhost:3306/_Gokul";
String dbUsername = "root";
String dbPassword = "gokul@14";

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;
int rows=0;

try {
    // Get user input
    String name = request.getParameter("email");
    String password = request.getParameter("password");
    String rollno = request.getParameter("rollno");

    // Load JDBC driver
    Class.forName("com.mysql.cj.jdbc.Driver");

    // Establish connection
    con = DriverManager.getConnection(url, dbUsername, dbPassword);

    // Check if the user exists in AccountCreation table
    String selectQuery = "SELECT * FROM AccountCreation WHERE emailid = ? AND password = ? AND rollno = ?";
    
    ps = con.prepareStatement(selectQuery);
    ps.setString(1, name);
    ps.setString(2, password);
    ps.setString(3, rollno);
    rs = ps.executeQuery();

    if (rs.next()) 
    {
        // User exists, insert into login table
        String insertQuery = "INSERT INTO login (emailid, password, rollno) VALUES (?, ?, ?)";
        ps = con.prepareStatement(insertQuery);
        ps.setString(1, name);
        ps.setString(2, password);
        ps.setString(3, rollno);
        rows = ps.executeUpdate();

        if (rows >0) 
        {
            // Redirect to Quiz.html if insert was successful
            response.sendRedirect("Quiz.html");
        } else {
            // Notify the user if insert failed
            %>
            <script>
                alert("Error occurred while registering. Please try again.");
                window.location.href = "index.html";
            </script>
            <%
        }
    } 
    else {
        // Notify the user if the user is not found
        %>
        <script>
            alert("Please Register First");
            window.location.href = "index.html";
        </script>
        <%
    }
} 
catch (Exception e) {
    out.println(e);
} finally {
    // Close resources
    try {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (con != null) con.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
%>

</body>
</html>
