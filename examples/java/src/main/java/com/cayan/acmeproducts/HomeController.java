package com.cayan.acmeproducts;

import java.util.Locale;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import com.merchantwarehouse.schemas.merchantware._40.credit.*;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
  
  private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
  
  /**
   * Simply selects the home view to render by returning its name.
     * @param locale
     * @param model
     * @return 
   */
  @RequestMapping(value = "/", method = RequestMethod.GET)
  public String home(final Locale locale, final Model model) {
    logger.info("Welcome home! The client locale is {}.", locale);
    
    model.addAttribute("referenceNumber", "0");
    model.addAttribute("amount", "1.65");
    
    return "home";
  }
  
    /**
   * Simply selects the home view to render by returning its name.
     * @param token
     * @param locale
     * @param model
     * @return 
   */
  @RequestMapping(value = "/", method = RequestMethod.POST)
  public String homePost(final @RequestParam("TokenHolder") String token, final Locale locale, final Model model) {

    String merchantName = "TEST";
    String merchantSiteId = "XXXXXXXX";
    String merchantKey = "XXXXX-XXXXX-XXXXX-XXXXX-XXXXX";
    String invoiceNumber = "99123";
    String amount = "1.65";
    String vaultToken = token;
    String forceDuplicate = "true";
    String registerNumber = "123";
    String merchantTransactionId = "1234";

    Credit c = new Credit();
    CreditSoap cs = c.getCreditSoap();
    CreditResponse4 svr = cs.saleVault(merchantName, merchantSiteId, merchantKey, invoiceNumber, amount, vaultToken, forceDuplicate, registerNumber, merchantTransactionId);

    model.addAttribute("amount", svr.getAmount());
    model.addAttribute("referenceNumber", svr.getToken());
    return "home";
  }

}
