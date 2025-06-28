package controller;

import dao.BoardDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Board;

import java.io.IOException;

@WebServlet("/Board")
public class BoardController extends HttpServlet {
    private BoardDAO boardDAO;

    @Override
    public void init() {
        boardDAO = new BoardDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            switch (action) {
                case "add":
                    addBoard(request);
                    break;
                case "edit":
                    editBoard(request);
                    break;
                case "delete":
                    deleteBoard(request);
                    break;
                case "moveBoardPosition":
                    moveBoardPosition(request);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        int projectId = Integer.parseInt(request.getParameter("projectId"));
        response.sendRedirect("Task.jsp?projectId=" + projectId);
    }

    private void addBoard(HttpServletRequest request) throws Exception {
        String name = request.getParameter("name");
        int projectId = Integer.parseInt(request.getParameter("projectId"));
        int position = Integer.parseInt(request.getParameter("position"));
        Board board = new Board(0, projectId, name, "", null);
        board.setPosition(position);

        boardDAO.insert(board);
    }

    private void editBoard(HttpServletRequest request) throws Exception {
        int boardId = Integer.parseInt(request.getParameter("listId"));
        String name = request.getParameter("name");

        Board board = boardDAO.findById(boardId);
        board.setName(name);
        boardDAO.update(board);
    }

    private void deleteBoard(HttpServletRequest request) throws Exception {
        int boardId = Integer.parseInt(request.getParameter("listId"));
        boardDAO.delete(boardId);
    }

    private void moveBoardPosition(HttpServletRequest request) throws Exception {
        String[] boardIds = request.getParameterValues("boardIds[]");
        String[] positions = request.getParameterValues("positions[]");

        if (boardIds != null && positions != null) {
            for (int i = 0; i < boardIds.length; i++) {
                int boardId = Integer.parseInt(boardIds[i]);
                int position = Integer.parseInt(positions[i]);
                boardDAO.updateBoardPosition(boardId, position);
            }
        }
    }
}
