import streamlit as st
from streamlit.web.server.websocket_headers import _get_websocket_headers

st.set_page_config(
    page_title="Debugger",
    page_icon="👋",
)

st.write("# Welcome to the Streamlit Azure Ad demo! 👋")

st.sidebar.success("Select a demo above.")


def logout(logout_link):
    logout_link()


headers = _get_websocket_headers()

if 'key' not in st.session_state:
    st.session_state['key'] = 'value'

st.write(st.session_state['key'])

if "X-Ms-Client-Principal-Name" in headers:
    user_email = headers["X-Ms-Client-Principal-Name"]


if "Origin" in headers:
    origin = headers["Origin"]
     


st.write("Welcome email:", user_email)



st.write(headers) # have a look at what else is in the dict


st.title("Streamlit Azure AD Logout Example")

# Create a Streamlit button for logout
if st.button("Logout"):
   
    logout_link = f'<a href="{origin}/.auth/logout" target="_blank">Logout</a>'
    st.markdown("Logging out...")
    logout(logout_link)
    #st.markdown(logout_link, unsafe_allow_html=True)


st.markdown(
    """

"""
)