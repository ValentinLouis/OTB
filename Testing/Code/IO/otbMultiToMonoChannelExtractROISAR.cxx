/*=========================================================================

  Programme :   OTB (ORFEO ToolBox)
  Auteurs   :   CS - T.Feuvrier
  Language  :   C++
  Date      :   11 janvier 2005
  Version   :   
  Role      :   Test l'extraction d'une ROI dans une image mono ou multi canal, dont les valeurs sont cod�es en "unsigned char"
                Les parametres de la ROI ne sont pas obligatoire, tout comme les canaux. Dans ce cas, les valeurs par d�faut 
                de la classe sont utilis�es
                
  $Id$

=========================================================================*/

#include "itkExceptionObject.h"

#include "otbImageFileReader.h"
#include "otbImageFileWriter.h"
#include "otbMultiToMonoChannelExtractROI.h"

int otbMultiToMonoChannelExtractROISAR ( int argc, char ** argv )
{
  try 
    { 

        const char * inputFilename  = argv[1];
        const char * outputFilename = argv[2];

        typedef std::complex<int>  	                                InputPixelType;
        typedef std::complex<int>  	                                OutputPixelType;


        typedef otb::MultiToMonoChannelExtractROI< InputPixelType, 
                                             OutputPixelType >  ExtractROIFilterType;

        ExtractROIFilterType::Pointer extractROIFilter = ExtractROIFilterType::New();

	extractROIFilter->SetStartX( 10 );
	extractROIFilter->SetStartY( 10 );
	extractROIFilter->SetSizeX( 100 );
	extractROIFilter->SetSizeY( 100 );
	extractROIFilter->SetChannel( 1 );
	
	// Resume de la ligne de commande
	std::cout << " ROI selectionnee : startX "<<extractROIFilter->GetStartX()<<std::endl;
	std::cout << "                    startY "<<extractROIFilter->GetStartY()<<std::endl;
	std::cout << "                    sizeX  "<<extractROIFilter->GetSizeX()<<std::endl;
	std::cout << "                    sizeY  "<<extractROIFilter->GetSizeY()<<std::endl;
	std::cout << " Canal selectionne : ("<<extractROIFilter->GetChannel()<<") : ";

        typedef otb::ImageFileReader< ExtractROIFilterType::InputImageType >       ReaderType;
        typedef otb::ImageFileWriter< ExtractROIFilterType::OutputImageType >       WriterType;
        ReaderType::Pointer reader = ReaderType::New();
        WriterType::Pointer writer = WriterType::New();

        reader->SetFileName( inputFilename  );
        writer->SetFileName( outputFilename );
	
        extractROIFilter->SetInput( reader->GetOutput() );        
        writer->SetInput( extractROIFilter->GetOutput() );
        writer->Update(); 
        std::cout << " Nb canaux dans l'image d'entree : "<< reader->GetOutput()->GetNumberOfComponentsPerPixel()<<std::endl;
        std::cout << " Nb canaux dans l'image de sortie : "<<extractROIFilter->GetOutput()->GetNumberOfComponentsPerPixel() <<std::endl;

    } 

  catch( itk::ExceptionObject & err ) 
    { 
    std::cout << "Exception itk::ExceptionObject levee !" << std::endl; 
    std::cout << err << std::endl; 
    return EXIT_FAILURE;
    } 
  catch( ... ) 
    { 
    std::cout << "Exception levee inconnue !" << std::endl; 
    return EXIT_FAILURE;
    } 


  return EXIT_SUCCESS;
}

