<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>


<html>
<body>
<%@ page import="java.sql.*" %>


<%

String url = "jdbc:mysql://localhost:3306/_Gokul";
String dbUsername = "root";
String dbPassword = "gokul@14";

Connection con=null;
PreparedStatement pst=null;
int rows = 0;


String name = request.getParameter("username");
String rollno = request.getParameter("rollno");
String gender = request.getParameter("gender");
String classname = request.getParameter("class");
String email = request.getParameter("email");
String userPassword = request.getParameter("password");


try {
	

Class.forName("com.mysql.cj.jdbc.Driver");
    con = DriverManager.getConnection(url, dbUsername, dbPassword);

    if (con != null) 
    {
        String query = "INSERT INTO AccountCreation VALUES (?, ?, ?, ?, ?, ?);";
        pst = con.prepareStatement(query);
        pst.setString(1, name);
        pst.setString(2, rollno);
        pst.setString(3, gender);
        pst.setString(4, classname);
        pst.setString(5, email);
        pst.setString(6, userPassword);

        rows = pst.executeUpdate();

        if (rows != 0)
        {
%>
            <script>
                alert("Successfully Registered");
            </script>
 
<%
response.sendRedirect("index.html");
        } 
        else
        {
%>
            <script>
                alert("Error occurred during registration. Please check.");
            </script>
<%
        }
    }
} 
catch (Exception e)
{
    out.println(e);
}
finally 
{
   
    try
    {
        if (pst != null)
        {
            pst.close();
        }
        if (con != null) 
        {
            con.close();
        }
    } catch (SQLException e) 
    {
        e.printStackTrace();
    }
}
%>

</body>
</html>
