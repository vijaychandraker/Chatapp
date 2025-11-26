<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserDashboard.aspx.cs" Inherits="chat2.UserDashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>User Dashboard</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f5f5;
        }
        
        .dashboard-header {
            background: #667eea;
            color: white;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .dashboard-header h1 {
            font-size: 24px;
        }
        
        .user-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .btn-logout {
            padding: 10px 20px;
            background: #f44336;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
        }
        
        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .welcome-box {
            background: white;
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .welcome-box h2 {
            color: #333;
            margin-bottom: 10px;
        }
        
        .chat-rooms-section {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .section-header h3 {
            color: #333;
        }
        
        .btn-new-chat {
            padding: 10px 20px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        
        .chat-room-card {
            background: #f9f9f9;
            padding: 20px;
            margin-bottom: 15px;
            border-radius: 8px;
            border-left: 4px solid #667eea;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .chat-room-card:hover {
            background: #f0f0f0;
            transform: translateX(5px);
        }
        
        .chat-room-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
        }
        
        .chat-room-info {
            font-size: 14px;
            color: #666;
        }
        
        .chat-room-date {
            font-size: 12px;
            color: #999;
            margin-top: 5px;
        }
        
        .no-chats {
            text-align: center;
            padding: 40px;
            color: #999;
        }
        
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
        }
        
        .modal-content {
            background: white;
            margin: 10% auto;
            padding: 30px;
            border-radius: 10px;
            width: 90%;
            max-width: 500px;
        }
        
        .modal-header {
            margin-bottom: 20px;
        }
        
        .modal-header h3 {
            color: #333;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #555;
            font-weight: 500;
        }
        
        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        
        .modal-buttons {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
        }
        
        .btn-cancel {
            padding: 10px 20px;
            background: #999;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="dashboard-header">
            <h1>Chat Application - User Dashboard</h1>
            <div class="user-info">
                <span>Welcome, <asp:Label ID="lblUserName" runat="server"></asp:Label></span>
                <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn-logout" OnClick="btnLogout_Click" />
            </div>
        </div>
        
        <div class="container">
            <div class="welcome-box">
                <h2>Welcome to Your Chat Dashboard</h2>
                <p>Connect with administrators and get support for your queries.</p>
            </div>
            
            <div class="chat-rooms-section">
                <div class="section-header">
                    <h3>My Chat Rooms</h3>
                    <asp:Button ID="btnNewChat" runat="server" Text="+ New Chat" CssClass="btn-new-chat" OnClick="btnNewChat_Click" />
                </div>
                
                <asp:Panel ID="pnlChatRooms" runat="server">
                    <asp:Repeater ID="rptChatRooms" runat="server">
                        <ItemTemplate>
                            <div class="chat-room-card" onclick="location.href='ChatRoom.aspx?id=<%# Eval("ChatRoomId") %>'">
                                <div class="chat-room-title"><%# Eval("RoomName") %></div>
                                <div class="chat-room-info">Admin: <%# Eval("AdminName") %></div>
                                <div class="chat-room-date">Created: <%# Convert.ToDateTime(Eval("CreatedDate")).ToString("MMM dd, yyyy") %></div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </asp:Panel>
                
                <asp:Panel ID="pnlNoChats" runat="server" Visible="false" CssClass="no-chats">
                    <p>No chat rooms yet. Click "New Chat" to start a conversation with an administrator.</p>
                </asp:Panel>
            </div>
        </div>
        
        <!-- New Chat Modal -->
        <asp:Panel ID="pnlNewChatModal" runat="server" CssClass="modal" style="display:none;">
            <div class="modal-content">
                <div class="modal-header">
                    <h3>Start New Chat</h3>
                </div>
                <div class="form-group">
                    <label>Chat Topic</label>
                    <asp:TextBox ID="txtChatTopic" runat="server" CssClass="form-control" placeholder="Enter your query topic"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Select Admin</label>
                    <asp:DropDownList ID="ddlAdmin" runat="server" CssClass="form-control"></asp:DropDownList>
                </div>
                <div class="modal-buttons">
                    <asp:Button ID="btnCancelModal" runat="server" Text="Cancel" CssClass="btn-cancel" OnClick="btnCancelModal_Click" />
                    <asp:Button ID="btnCreateChat" runat="server" Text="Create Chat" CssClass="btn-new-chat" OnClick="btnCreateChat_Click" />
                </div>
            </div>
        </asp:Panel>
    </form>
    
    <script type="text/javascript">
        function showModal() {
            document.getElementById('<%= pnlNewChatModal.ClientID %>').style.display = 'block';
        }
        
        function hideModal() {
            document.getElementById('<%= pnlNewChatModal.ClientID %>').style.display = 'none';
        }
        
        <%if (ViewState["ShowModal"] != null && (bool)ViewState["ShowModal"]) { %>
            showModal();
        <% } %>
    </script>
</body>
</html>
