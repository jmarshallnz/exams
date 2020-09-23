moodle2exams <- function(x, dir = NULL, exshuffle = TRUE)
{
  ## read Moodle XML file (if necessary)
  stopifnot(requireNamespace("xml2"))
  if(!inherits(x, "xml_node") && length(x) == 1L) x <- xml2::read_xml(x)

  ## set up template in indicated markup
  ## FIXME: markup currently hard-coded as "markdown" because "latex" needs more testing/improvements
  markup <- "markdown"
  if(markup == "markdown") markup <- "markdown_strict"
  if(!(markup %in% c("markdown_strict", "latex"))) stop("'markup' must be either markdown/markdown_strict or latex")
  fext <- if(markup == "markdown_strict") "Rmd" else "Rnw"
  tmpl <- if(markup == "markdown_strict") {

'Question
========
%s
%s

%s

Meta-information
================
exname: %s
extype: %s
exsolution: %s
%s
'

  } else {
  
'\\begin{question}
%s
%s
\\end{question}

%s

\\exname{%s}
\\extype{%s}
\\exsolution{%s}
%s
'

  }
  
  ## convenience functions
  answerlist_env <- function(x) {
    if(markup == "markdown_strict") {
      c("Answerlist", "----------", paste("*", x))
    } else {
      c("\\begin{answerlist}", paste("  \\item", x), "\\end{answerlist}")
    }
  }
  
  solution_env <- function(solutions, feedback) {
    if(length(solutions) > 0L) solutions <- answerlist_env(solutions)
    solutions <- c(feedback, solutions)
    solutions <- if(markup == "markdown_strict") {
      c("Solution", "========", solutions)
    } else {
      c("\\begin{solution}", solutions, "\\end{solutions}")
    }
  }
  
  name_to_file <- function(name) {
    name <- gsub(":|,|!", "", name)
    name <- gsub(" ", "_", name)
    for(i in c("...", "|", "/", "(", ")", "[", "]", "{", "}", "<", ">")) {
      name <- gsub(i, "", name, fixed = TRUE)
    }
    return(name)
  }

  ## extract questions
  ## FIXME: restrict question types some more?
  qu <- xml2::xml_find_all(x, "question")
  type <- xml2::xml_attr(qu, "type")
  qu <- qu[type != "category"]
  type <- type[type != "category"]
  n <- length(qu)
  if(n < 1L) stop("no <question> tags (of supported type)")
  
  ## set up variables for each question
  ## FIXME: currently name = NULL hard-coded, also let the user specify this?
  exrc <- vector(mode = "list", length = n)
  name <- NULL
  if(is.null(name)) {
    name <- rep.int("", n)
  } else {
    name <- rep_len(as.character(name), n)
    name[is.na(name) | duplicated(name)] <- ""
  }
  exshuffle <- rep_len(as.character(exshuffle), n)
  
  ## cycle through questions
  for(i in 1L:n) {
    ## cloze not fully supported yet
    if(type[i] == "cloze")
      warning("cloze conversion not fully supported yet!")
    qui <- xml2::xml_children(qu[[i]])
    qn <- xml2::xml_name(qui)
    if("questiontext" %in% qn) {
      qtext <- xml2::xml_text(qui[qn == "questiontext"])
      qtext <- pandoc(qtext,
        from = "html+tex_math_dollars+tex_math_single_backslash",
        to = markup)
      exsol <- extol <- feedback <- NULL
      answers <- solutions <- list()

      ## num
      if(type[i] == "numerical") {
        exsol <- xml2::xml_text(xml2::xml_children(qui[qn == "answer"])[1L])
        extol <- xml2::xml_children(qui[qn == "answer"])
        if("tolerance" %in% xml2::xml_name(extol))
          extol <- xml2::xml_text(extol[xml2::xml_name(extol) == "tolerance"])
      }
      
      ## schoice/mchoice
      if(type[i] == "multichoice") {
        single <- qui[qn == "single"]
        if(!is.null(single)) {
          single <- xml2::xml_text(single)
          single <- single == "true"
        } else {
          single <- FALSE
        }
        if(single)
          type[i] <- "singlechoice"
        ans <- qui[qn == "answer"]
        frac <- xml2::xml_attr(ans, "fraction")
        frac <- as.numeric(frac)
        sol <- frac > 0
        exsol <- paste0(sol * 1, collapse = "")
        for(j in 1L:length(ans)) {
          ac <- xml2::xml_children(ans[j])
          ac <- ac[xml2::xml_name(ac) == "text"]
          ac <- xml2::xml_text(ac)
          answers[[j]] <- pandoc(ac[1],
            from = "html+tex_math_dollars+tex_math_single_backslash",
            to = markup)
          if(length(ac) > 1L)
            solutions[[j]] <- pandoc(ac[2],
              from = "html+tex_math_dollars+tex_math_single_backslash",
              to = markup)
        }
      }
      
      ## string
      if(type[i] == "shortanswer") {
        ans <- xml2::xml_children(qui[qn == "answer"])
        exsol <- xml2::xml_text(ans[xml2::xml_name(ans) == "text"][1])
      }

      ## general feedback
      if("generalfeedback" %in% qn) {
        feedback <- qui[qn == "generalfeedback"]
        feedback <- xml2::xml_text(feedback)
        feedback <- pandoc(feedback,
          from = "html+tex_math_dollars+tex_math_single_backslash",
          to = markup)
      }

      ## name/label and type
      exname <- xml2::xml_text(qui[qn == "name"])
      extype <- switch(type[i],
        "numerical" = "num",
        "essay" = "string",
        "cloze" = "cloze",
        "multichoice" = "mchoice",
        "singlechoice" = "schoice",
        "shortanswer" = "string"
      )

      ## further meta-information tags
      exother <- if(type[i] == "numerical" && !is.null(extol)) {
        sprintf(if(markup == "markdown_strict") "extol: %s" else "\\extol{%s}", extol)
      } else if(type[i] == "multichoice") {
        sprintf(if(markup == "markdown_strict") "exshuffle: %s" else "\\exshuffle{%s}", exshuffle[i])
      } else {
        ""
      }

      ## insert information into template
      exrc[[i]] <- sprintf(tmpl,
        paste(qtext, collapse = "\n"),
	if(type[i] == "multichoice") paste(c("", answerlist_env(unlist(answers))), collapse = "\n") else "",
        if(length(solutions) >= 1L || !is.null(feedback)) paste(solution_env(solutions, feedback), collapse = "\n") else "",
	exname,
	extype,
	exsol,
	exother)
      
      ## default file name
      if(name[i] == "") name[i] <- name_to_file(exname)
    }
  }

  ## write/return resulting exercises
  names(exrc) <- name
  if(!is.null(dir)) {
    for(i in 1L:length(exrc)) {
      writeLines(exrc[[i]], file.path(dir, paste(name[i], fext, sep = ".")))
    }
    invisible(exrc)
  } else {
    return(exrc)
  }
}