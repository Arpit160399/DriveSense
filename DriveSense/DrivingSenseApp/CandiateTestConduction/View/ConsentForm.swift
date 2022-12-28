//
//  ConsentForm.swift
//  DriveSense
//
//  Created by Arpit Singh on 23/12/22.
//

import SwiftUI

struct ConsentForm: View {
    
    let accept: () -> Void
    let decline: () -> Void
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Consent Terms")
                        .multilineTextAlignment(.leading)
                        .font(.systemSubTitle)
                        .foregroundColor(.white)
                    formBody("""
                    By using our app, you consent to the collection, use, and sharing of your information as described in our
                    Privacy Policy.

                    You also consent to the use of location data and the data collected from the app's telematics functionality
                    for the purpose of improving driver training and contributing to the development of autonomous driving
                    models.

                    If you do not agree to these terms, do not use our app. If you have already started using the app and
                    no longer consent to these terms, you may stop using the app and contact us at support@Drive_Sense.com
                    to request the deletion of your personal information.
                    """)
                    Text("Privacy Policy & Terms")
                        .multilineTextAlignment(.leading)
                        .font(.systemSubTitle)
                        .foregroundColor(.white)
                        .padding()
                    formBody("""
At Driver Training App, we are committed to protecting the privacy of our users. This Privacy Policy
explains how we collect, use, and share information when you use our app and related services.

By using our app, you agree to the collection, use, and sharing of your information as described in
this Privacy Policy. If you do not agree with our policies and practices, do not use our app.

We may change our Privacy Policy from time to time. We encourage you to review the Privacy Policy whenever
you access our app to stay informed about our information practices and the choices available to you.

Information We Collect

We collect information you provide directly to us when you use our app. This may include personal
information such as your name, email address, phone number, and any other information you choose
to provide.

We may also collect location information when you use our app. This may include GPS data or
information there device accelerometer , gyroscope and barometers.

We may also collect information about how you use our app, including the instructors feedback that was
obtained during the mock test.

Use of Information

We use the information we collect to analyse different the driving pattern or in some further research.
This may include using the information to:

As training dataset for AI Models.
Deriving different driving profile or pattern.
Understanding different factors that affect driving.

Sharing of Information

We may share the information we collect with third parties in the following circumstances:

With service providers and partners who assist us in operating our app and providing related services
With law enforcement or other government agencies in response to a legal request or in the event of
a security incident.
In connection with a merger, acquisition, or sale of all or a portion of our assets

Data Retention

We will retain your information for as long as your account is active or as needed to provide you
with our app and related services. We may also retain and use your information to comply
with legal obligations, resolve disputes, and enforce our agreements.

Security

We take reasonable measures to protect the information we collect from unauthorised access, use, or
disclosure. However, no method of transmission over the internet or method of electronic storage is
completely secure, and we cannot guarantee the absolute security of your information.

Contact Us

If you have any questions or concerns about our Privacy Policy or the information we collect, please
contact us at [insert contact information].
""")
                }
            }
            HStack {
                Button(action: {
                    accept()
                }, label: {
                    Text("Accept")
                })
                .buttonStyle(PrimaryButton(loading: .constant(false)))
                Spacer()
                Button(action: {
                    decline()
                }, label: {
                    Text("Decline")
                })
                .buttonStyle(PrimaryButton(loading: .constant(false),
                                           color: .appPeach))
            }.padding()
        }
        .padding(10)
        .background(Color.appOrangeLevel.edgesIgnoringSafeArea(.all))
    }
    
    func formBody(_ text: String) -> some View {
        return Text(text)
            .multilineTextAlignment(.center)
            .lineLimit(100)
            .font(.systemCaption2)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity)
            .padding()
            .background(Color.appOrange)
            .cornerRadius(8)
    }
}

struct ConsentForm_Previews: PreviewProvider {
    static var previews: some View {
        ConsentForm {
            
        } decline: {
        }
    }
}
