#!/bin/sh

ADRNUM=$(gh api graphql --jq '.data.repository.discussions.nodes[].title' -f query='query {
     repository(owner: "m-hamashita", name: "study-github-actions") {
       discussions(first: 10) {
         nodes {
           title
         }
       }
     }
 }'| sed -e 's/ADR \([0-9]*\).*/\1/' | awk '$0>x{x=$0};END{print x+1}')

title="ADR "$ADRNUM". "$1
body=$(cat ./.github/workflows/sample_discussion_body)
gh api graphql -f "body=$body" -f "title=$title" -f query='mutation CreateDiscussion($title: String!, $body: String!){
      createDiscussion(input: {repositoryId: "R_kgDOIXQxIg", categoryId: "DIC_kwDOIXQxIs4CSWZz", body: $body, title: $title}) {

        # response type: CreateDiscussionPayload
        discussion {
          id
        }
      }
    }'
