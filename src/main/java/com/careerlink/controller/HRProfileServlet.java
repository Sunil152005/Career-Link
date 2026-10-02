package com.careerlink.controller;

import com.careerlink.dao.HRDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Map;

@WebServlet("/hr-profile")
public class HRProfileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Map<String, Object> hr = (Map<String, Object>) session.getAttribute("hr");

        if (hr == null) {
            response.sendRedirect("login.jsp?role=hr");
            return;
        }

        int hrId = (Integer) hr.get("hrId");
        String companyName = request.getParameter("companyName");
        String hrName = request.getParameter("hrName");
        String mobile = request.getParameter("mobile");
        String newPassword = request.getParameter("newPassword");

        HRDAO hrDao = new HRDAO();
        boolean success = hrDao.updateProfile(hrId, companyName != null ? companyName.trim() : "", 
                                            hrName != null ? hrName.trim() : "", 
                                            mobile != null ? mobile.trim() : "");


        if (success) {
            Map<String, Object> updated = hrDao.getHRById(hrId);
            session.setAttribute("hr", updated);
            response.sendRedirect("hr/profile.jsp?success=true");
        } else {
            response.sendRedirect("hr/profile.jsp?error=true");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
