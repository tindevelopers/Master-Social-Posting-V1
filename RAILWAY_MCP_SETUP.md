# Railway MCP Server Setup

## 🚀 What is Railway MCP Server?

The Railway MCP (Model Context Protocol) Server allows you to manage your Railway infrastructure using natural language commands through AI assistants like Cursor or VS Code.

## ✅ Installation Complete

The Railway MCP server has been configured for this project with the following files:

- `.cursor/mcp.json` - Cursor IDE configuration
- `.vscode/mcp.json` - VS Code configuration
- `package.json` - Added `railway:mcp` script

## 🔧 How to Use

### **Option 1: Through Cursor IDE**
1. Restart Cursor IDE
2. The Railway MCP server will be automatically available
3. You can now ask Cursor to manage your Railway infrastructure

### **Option 2: Through VS Code**
1. Install the MCP extension for VS Code
2. Restart VS Code
3. The Railway MCP server will be available

### **Option 3: Command Line**
```bash
# Run the Railway MCP server directly
pnpm run railway:mcp

# Or use npx directly
npx -y @railway/mcp-server
```

## 🎯 What You Can Do

With the Railway MCP server, you can now:

### **Project Management**
- "Create a new Railway project"
- "List all my Railway projects"
- "Delete a Railway project"

### **Service Management**
- "Deploy my app to Railway"
- "Scale my service to 3 instances"
- "View service logs"
- "Restart my service"

### **Database Management**
- "Create a PostgreSQL database"
- "Create a Redis instance"
- "View database connection details"

### **Environment Variables**
- "Set environment variable NODE_ENV to production"
- "List all environment variables"
- "Delete environment variable API_KEY"

### **Monitoring**
- "Show me service metrics"
- "View deployment history"
- "Check service health"

## 🔐 Prerequisites

Before using the Railway MCP server, ensure you have:

1. **Railway CLI installed**:
   ```bash
   npm install -g @railway/cli
   ```

2. **Authenticated with Railway**:
   ```bash
   railway login
   ```

3. **Project linked** (optional):
   ```bash
   railway link
   ```

## 📋 Example Commands

Once set up, you can use natural language commands like:

- "Deploy this project to Railway"
- "Create a PostgreSQL database for my app"
- "Set up environment variables for production"
- "Show me the deployment status"
- "Scale my frontend service to 2 instances"
- "View the logs for my backend service"

## 🆘 Troubleshooting

### **MCP Server Not Working**
1. Ensure Railway CLI is installed and authenticated
2. Restart your IDE (Cursor/VS Code)
3. Check that the MCP configuration files are in place

### **Permission Issues**
1. Make sure you're logged into Railway: `railway login`
2. Verify you have access to the Railway project
3. Check your Railway account permissions

### **Connection Issues**
1. Verify your internet connection
2. Check Railway service status
3. Try running `railway status` to verify CLI connectivity

## 🔗 Useful Links

- [Railway MCP Server GitHub](https://github.com/railwayapp/railway-mcp-server)
- [Railway CLI Documentation](https://docs.railway.app/cli)
- [Model Context Protocol](https://modelcontextprotocol.io/)

---

**Ready to use!** The Railway MCP server is now configured and ready to help you manage your Railway infrastructure through natural language commands. 🚀
