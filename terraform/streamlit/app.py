import streamlit as st
from streamlit.web.server.websocket_headers import _get_websocket_headers

st.set_page_config(
    page_title="Debugger",
    page_icon="👋",
)

st.write("# Welcome to the Streamlit Azure Ad demo! 👋")

st.sidebar.success("Select a demo above.")


headers = _get_websocket_headers()

if 'key' not in st.session_state:
    st.session_state['key'] = 'value'


if "X-Ms-Client-Principal-Name" in headers:
    user_email = headers["X-Ms-Client-Principal-Name"]

st.write("Welcome email:", user_email)

st.write(headers) # have a look at what else is in the dict


st.markdown(
    """

"""
)