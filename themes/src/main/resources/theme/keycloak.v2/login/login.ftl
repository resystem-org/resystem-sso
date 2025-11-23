<#import "template.ftl" as layout>
<#import "field.ftl" as field>
<#import "buttons.ftl" as buttons>
<#import "social-providers.ftl" as identityProviders>
<#import "passkeys.ftl" as passkeys>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username','password') displayInfo=realm.password && realm.registrationAllowed && !registrationDisabled??; section>
<!-- template: login.ftl -->

    <#if section = "header">
        ${msg("loginAccountTitle")}
    <#elseif section = "form">
        <div class="reid-auth-grid">
          <section class="reid-hero-panel" aria-label="ReID identity overview">
            <p class="reid-hero-kicker">Welcome back</p>
            <h2 class="reid-hero-title">ReID keeps your workforce identities trusted and connected.</h2>
            <ul class="reid-hero-list">
              <li>Adaptive security that meets every authentication step.</li>
              <li>Unified access for teams, partners, and applications.</li>
              <li>Clear guidance so you can sign in with confidence.</li>
            </ul>
            <div class="reid-hero-meta">
              <span class="reid-badge">ReID</span>
              <span class="reid-hero-note">Enterprise identity, simplified.</span>
            </div>
          </section>
          <div id="kc-form" class="reid-form-card">
            <div id="kc-form-wrapper">
              <#if realm.password>
                  <form id="kc-form-login" class="${properties.kcFormClass!}" onsubmit="login.disabled = true; return true;" action="${url.loginAction}" method="post" novalidate="novalidate">
                      <#if !usernameHidden??>
                          <#assign label>
                              <#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if>
                          </#assign>
                          <@field.input name="username" label=label error=kcSanitize(messagesPerField.getFirstError('username','password'))?no_esc
                              autofocus=true autocomplete="${(enableWebAuthnConditionalUI?has_content)?then('username webauthn', 'username')}" value=login.username!'' />
                          <@field.password name="password" label=msg("password") error="" forgotPassword=realm.resetPasswordAllowed autofocus=usernameHidden?? autocomplete="current-password">
                              <#if realm.rememberMe && !usernameHidden??>
                                  <@field.checkbox name="rememberMe" label=msg("rememberMe") value=login.rememberMe?? />
                              </#if>
                          </@field.password>
                      <#else>
                          <@field.password name="password" label=msg("password") forgotPassword=realm.resetPasswordAllowed autofocus=usernameHidden?? autocomplete="current-password">
                              <#if realm.rememberMe && !usernameHidden??>
                                  <@field.checkbox name="rememberMe" label=msg("rememberMe") value=login.rememberMe?? />
                              </#if>
                          </@field.password>
                      </#if>

                      <input type="hidden" id="id-hidden-input" name="credentialId" <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if>/>
                      <@buttons.loginButton />
                  </form>
              </#if>
              </div>
          </div>
        </div>
        <@passkeys.conditionalUIData />
    <#elseif section = "socialProviders" >
        <#if realm.password && social.providers?? && social.providers?has_content>
            <@identityProviders.show social=social/>
        </#if>
    <#elseif section = "info" >
        <#if realm.password && realm.registrationAllowed && !registrationDisabled??>
            <div id="kc-registration-container" class="reid-secondary-panel">
                <div id="kc-registration">
                    <p class="reid-secondary-title">New to ReID?</p>
                    <p class="reid-secondary-copy">Create your account to unlock seamless access across your teams and services.</p>
                    <a class="reid-link" href="${url.registrationUrl}">${msg("doRegister")}</a>
                </div>
            </div>
        </#if>
    </#if>

</@layout.registrationLayout>
