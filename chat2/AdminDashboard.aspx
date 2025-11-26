<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="chat2.AdminDashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Dashboard</title>
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
            background: #2c3e50;
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
            background: #e74c3c;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        
        .container {
            max-width: 1400px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        .stat-number {
            font-size: 36px;
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 10px;
        }
        
        .stat-label {
            font-size: 14px;
            color: #7f8c8d;
            text-transform: uppercase;
        }
        
        .tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }
        
        .tab-button {
            padding: 12px 24px;
            background: white;
            border: 2px solid #ddd;
            border-radius: 5px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s;
        }
        
        .tab-button.active {
            background: #2c3e50;
            color: white;
            border-color: #2c3e50;
        }
        
        .tab-content {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .chat-room-card {
            background: #f9f9f9;
            padding: 20px;
            margin-bottom: 15px;
            border-radius: 8px;
            border-left: 4px solid #2c3e50;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .chat-room-card:hover {
            background: #f0f0f0;
            transform: translateX(5px);
        }
        
        .chat-room-details {
            flex: 1;
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
        
        .unread-badge {
            background: #e74c3c;
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }
        
        .users-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .users-table th {
            background: #2c3e50;
            color: white;
            padding: 12px;
            text-align: left;
        }
        
        .users-table td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
        }
        
        .users-table tr:hover {
            background: #f9f9f9;
        }
        
        .no-data {
            text-align: center;
            padding: 40px;
            color: #999;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        
        <div class="dashboard-header">
            <h1>Admin Dashboard - Chat Management</h1>
            <div class="user-info">
                <span>Admin: <asp:Label ID="lblAdminName" runat="server"></asp:Label></span>
                <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn-logout" OnClick="btnLogout_Click" />
            </div>
        </div>
        
        <div class="container">
            <div class="stats-container">
                <div class="stat-card">
                    <div class="stat-number"><asp:Label ID="lblTotalChats" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Active Chats</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><asp:Label ID="lblTotalUsers" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Registered Users</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><asp:Label ID="lblTotalMessages" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Total Messages</div>
                </div>
            </div>
            
            <div class="tabs">
                <asp:Button ID="btnTabChats" runat="server" Text="Chat Rooms" CssClass="tab-button active" OnClick="btnTabChats_Click" />
                <asp:Button ID="btnTabUsers" runat="server" Text="Users" CssClass="tab-button" OnClick="btnTabUsers_Click" />
            </div>
            
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <asp:Panel ID="pnlChats" runat="server" CssClass="tab-content">
                        <h3 style="margin-bottom: 20px;">All Chat Rooms</h3>
                        <asp:Repeater ID="rptChatRooms" runat="server">
                            <ItemTemplate>
                                <div class="chat-room-card" onclick="location.href='ChatRoom.aspx?id=<%# Eval("ChatRoomId") %>'">
                                    <div class="chat-room-details">
                                        <div class="chat-room-title"><%# Eval("RoomName") %></div>
                                        <div class="chat-room-info">User: <%# Eval("UserName") %> | Admin: <%# Eval("AdminName") %></div>
                                        <div class="chat-room-date">Created: <%# Convert.ToDateTime(Eval("CreatedDate")).ToString("MMM dd, yyyy hh:mm tt") %></div>
                                    </div>
                                    <%# Convert.ToInt32(Eval("UnreadCount")) > 0 ? 
                                        "<span class='unread-badge'>" + Eval("UnreadCount") + " New</span>" : "" %>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        
                        <asp:Panel ID="pnlNoChats" runat="server" Visible="false" CssClass="no-data">
                            <p>No chat rooms available.</p>
                        </asp:Panel>
                    </asp:Panel>
                    
                    <asp:Panel ID="pnlUsers" runat="server" CssClass="tab-content" Visible="false">
                        <h3 style="margin-bottom: 20px;">Registered Users</h3>
                        <asp:GridView ID="gvUsers" runat="server" CssClass="users-table" AutoGenerateColumns="False">
                            <Columns>
                                <asp:BoundField DataField="UserId" HeaderText="ID" />
                                <asp:BoundField DataField="Username" HeaderText="Username" />
                                <asp:BoundField DataField="FullName" HeaderText="Full Name" />
                                <asp:BoundField DataField="Email" HeaderText="Email" />
                                <asp:BoundField DataField="CreatedDate" HeaderText="Joined Date" DataFormatString="{0:MMM dd, yyyy}" />
                                <asp:BoundField DataField="LastLoginDate" HeaderText="Last Login" DataFormatString="{0:MMM dd, yyyy hh:mm tt}" />
                            </Columns>
                        </asp:GridView>
                        
                        <asp:Panel ID="pnlNoUsers" runat="server" Visible="false" CssClass="no-data">
                            <p>No users registered yet.</p>
                        </asp:Panel>
                    </asp:Panel>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </form>
</body>
</html>