*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}       https://sellout-oppomex-training.possefy.co.th/staff/lists-v2?keyword=R118099&status=1&group_catty=&department_id=
${KEYWORD}   R118099
${USERNAME}  admin
${PASSWORD}  password

*** Test Cases ***
Edit Record Test
    Open Browser    ${URL}    chrome
    Maximize Browser Window
    ${is_login}=    Run Keyword And Return Status    Wait Until Element Is Visible    css:.login.username-field    5s
    Run Keyword If    ${is_login}    Login To Application
    Go To    ${URL}
    Wait Until Element Is Visible    xpath=//tr[td[contains(text(),"${KEYWORD}")]]//a[@title="Edit"]    20s
    Scroll Element Into View         xpath=//tr[td[contains(text(),"${KEYWORD}")]]//a[@title="Edit"]
    Sleep    1s
    # พยายามคลิกแบบปกติก่อน
    Run Keyword And Ignore Error    Click Element    xpath=//tr[td[contains(text(),"${KEYWORD}")]]//a[@title="Edit"]
    Sleep    1s
    # ถ้ายังไม่ได้ผล ให้ใช้ JavaScript คลิก element
    Execute JavaScript    document.evaluate('//tr[td[contains(text(),"${KEYWORD}")]]//a[@title="Edit"]', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click();
    Sleep    2s
    Close Browser

*** Keywords ***
Login To Application
    Sleep    1s
    Input Text    css:input.login.username-field    ${USERNAME}
    Input Text    css:input.login.password-field    ${PASSWORD}
    Press Keys    css:input.login.password-field    ENTER
